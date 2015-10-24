module Raindrops
  class DownloadsController < ApplicationController

    before_action :set_download, only: [:index, :create]
    before_action :set_downloads, only: [:index, :create]

    # GET /
    #
    # Affiche la liste des téléchargements en cours
    # Affiche le formulaire de téléchargement
    def index
    end

    # POST /
    #
    # Ajoute un téléchargement
    def create
      # http://ipv4.download.thinkbroadband.com/50MB.zip
      @download.destination_path = "/home/nicolas/Bureau/#{SecureRandom.hex}.zip"
      if @download.valid?
        download = Raindrops::Download.new source_url: @download.source_url,
                                           destination_path: @download.destination_path
        download.save
        download.delay.start
      end

      render :index
    end

    private

    def download_params
      if params.has_key?(:download)
        params.require(:download).permit(:source_url)
      else
        {}
      end
    end

    def set_download
      @download = Raindrops::Download.new download_params
    end

    def set_downloads
      @downloads = Raindrops::Download.all
    end

  end
end
