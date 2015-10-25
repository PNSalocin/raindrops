module Raindrops
  class Download < ActiveRecord::Base

    validates :source_url, presence: true
    validates :source_url, format: { with: URI.regexp }, if: proc { |a| a.source_url.present? }
    validates :destination_path, presence: true

    after_initialize :default_values

    enum status: { unprocessed: 0, downloading: 10, completed: 20,
                   error_opening_file: -10 }

    attr_accessor :verbose

    # Démarre le téléchargement
    def start
      require 'net/http'
      Net::HTTP.new(source_uri.host, source_uri.port).request_get(source_uri.path) do |response|
        puts "File found @#{source_uri}." if verbose
        file_size = get_and_update_file_total_size response
        return unless file = open_destination_file
        self.update_attributes! status: Raindrops::Download.statuses[:downloading]

        bytes_downloaded = 0
        old_percent_downloaded = 0
        puts 'Starting download'

        response.read_body do |chunk|
          bytes_downloaded += chunk.length
          percent_downloaded = (bytes_downloaded * 100) / file_size

          if percent_downloaded != old_percent_downloaded
            puts "#{percent_downloaded}/100% downloaded."
            self.update_attributes! file_downloaded_size: bytes_downloaded
          end

          old_percent_downloaded = percent_downloaded
          file.write chunk
        end

        puts 'STOP DOWNLOAD'
        self.update_attributes! status: Raindrops::Download.statuses[:completed]
      end
    end

    # Retourne le pourcentage actuel de progression de téléchargement du fichier
    #
    # *Returns* :
    #   - _Integer_
    def progress
      file_total_size && file_downloaded_size ? (file_downloaded_size.to_f / file_total_size.to_f * 100).to_i : 0
    end

    private

    # Assigne les valeurs par défaut au modèle
    def default_values
      self.verbose ||= true
    end

    def get_and_update_file_total_size(response)
      file_total_size = response.header['Content-Length'].to_i
      puts "File total size: #{file_total_size}." if verbose
      self.update_attributes! file_total_size: file_total_size
      file_total_size
    end

    # Retourne un objet URI correspondant à l'url source
    #
    # *Returns* :
    #   - _URI_
    def source_uri
      @source_uri = URI(source_url) unless @source_uri
      @source_uri
    end

    # Tente d'ouvrir le fichier de destination
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


    def close_file

    end
  end
end
