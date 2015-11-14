module Raindrops
  # Controlleur de gestion des téléchargements
  class DownloadsController < ApplicationController

    before_action :set_download_by_id, only: [:destroy]
    before_action :set_download, only: [:index, :create]
    before_action :set_downloads, only: [:index, :create]

    # Affiche la liste des téléchargements en cours, ainsi que le formulaire de téléchargement.
    #
    # @route [GET] /downloads
    def index
      respond_to do |format|
        format.html
        format.json
      end
    end

    # Ajoute un téléchargement.
    #
    # @route [POST] /downloads
    def create
      # @todo Retirer cette constante en dur
      @download.destination_path = "/home/nicolas/Bureau/#{SecureRandom.hex}.zip"
      if @download.valid?
        download = Raindrops::Download.new source_url: @download.source_url,
                                           destination_path: @download.destination_path
        download.save
        download.delay.start
      end

      render :index
    end

    # Efface un téléchargement
    #
    # @route [DELETE] /download/:id
    def destroy
      @download.destroy!
      redirect_to action: :index, status: 303
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
