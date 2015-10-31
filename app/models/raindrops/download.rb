module Raindrops
  # Modèle identifiant un téléchargement planifié, en cours ou terminé
  class Download < ActiveRecord::Base

    validates :source_url, presence: true
    validates :source_url, format: { with: URI.regexp }, if: proc { |a| a.source_url.present? }
    validates :destination_path, presence: true

    after_initialize :default_values

    enum status: { unprocessed: 0, downloading: 10, completed: 20, error_opening_file: -10 }

    attr_accessor :verbose

    # Retourne le nombre d'octets téléchargés du fichier
    #
    # *Returns* :
    # - _Integer_
    def bytes_downloaded
      File.exist?(destination_path) ? File.size(destination_path) : 0
    end

    # Retourne le pourcentage actuel de progression de téléchargement du fichier
    #
    # *Returns* :
    # _Integer_
    def progress
      (bytes_downloaded.to_f / file_size.to_f * 100).round 2
    end

    # Démarre le téléchargement
    def start
      require 'net/http'

      # Requête de base de récupération du fichier
      Net::HTTP.new(source_uri.host, source_uri.port).request_get(source_uri.path) do |response|
        puts "File found @#{source_uri}." if verbose

        get_and_update_file_size response

        # Tentative d'ouverture du fichier de destination en vue d'ecrire les chunks reçus
        file = open_destination_file
        return nil unless file

        self.update_attributes! status: Raindrops::Download.statuses[:downloading]
        puts 'Starting download' if verbose

        # Récupération des données du fichier par chunks
        response.read_body do |chunk|
          file.write chunk
        end

        self.update_attributes! status: Raindrops::Download.statuses[:completed]
        close_destination_file file
      end
    end

    private

    # Assigne les valeurs par défaut au modèle
    def default_values
      self.verbose ||= true
    end

    # Récupère la taille du fichier à télécharger par la réponse, met à jour le modèle et retourne cette taille
    #
    # *Params* :
    # - _Hash_ +response+ Réponse HTTP
    # *Returns* :
    # - _Integer_ : Taille en octets
    def get_and_update_file_size(response)
      file_size = response.header['Content-Length'].to_i
      puts "File size: #{file_size}." if verbose
      self.update_attributes! file_size: file_size
      file_size
    end

    # Retourne un objet URI correspondant à l'url source
    #
    # *Returns* :
    # - _URI_
    def source_uri
      @source_uri = URI(source_url) unless @source_uri
      @source_uri
    end

    # Tente d'ouvrir le fichier de destination
    #
    # *Returns* :
    # - _File|false_ Le fichier de destination si ok, false dans le cas contraire
    def open_destination_file
      puts "Trying to open destination file @#{destination_path}." if verbose
      begin
        file = ::File.open destination_path, 'wb'
        puts 'Destination file opened.' if verbose
        file
      rescue SystemCallError => e
        self.update_attributes! status: Raindrops::Download.statuses[:error_opening_file], error_content: e.message
        false
      end
    end

    # Ferme le fichier de destination
    def close_destination_file(file)
      file.close
      puts 'Destination file closed' if verbose
    end
  end
end
