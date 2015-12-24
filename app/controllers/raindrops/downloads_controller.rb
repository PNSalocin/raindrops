module Raindrops
  # Controlleur de gestion des téléchargements
  class DownloadsController < ApplicationController

    before_action :set_download_by_id, only: [:destroy]
    before_action :set_download, only: [:index, :create]
    before_action :set_downloads, only: [:index, :create]

    # Retourne la liste des téléchargements
    #
    # @route [GET] /downloads
    def index
      render json: @downloads
    end

    # Ajoute un téléchargement.
    #
    # @route [POST] /downloads
    def create
      @download.destination_path = "/home/nicolas/Bureau/#{SecureRandom.hex}.zip"

      @download.save!
      Raindrops::DownloadStartJob.perform_later @download
      render status: :ok
    end

    # Efface un téléchargement
    #
    # @route [DELETE] /download/:id
    def destroy
      @download.destroy!
      render status: :ok
    end

    private

    # Validation des paramètres de téléchargement
    def download_params
      if params.key?(:download)
        params.require(:download).permit(:source_url)
      else
        {}
      end
    end

    # Récupération d'un téléchargement par ID
    def set_download_by_id
      @download = Raindrops::Download.find params[:id]
    end

    # Instanciation d'un téléchargement en fonctions des paramètres en entrée
    def set_download
      @download = Raindrops::Download.new download_params
    end

    # Récupération de l'intégralité des téléchargements
    def set_downloads
      @downloads = Raindrops::Download.all
    end
  end
end
