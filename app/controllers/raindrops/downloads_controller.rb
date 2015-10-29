module Raindrops
  # Controlleur de gestion des téléchargements
  class DownloadsController < ApplicationController
    include ActionController::Live

    before_action :set_download_by_id, only: [:destroy]
    before_action :set_download, only: [:index, :create]
    before_action :set_downloads, only: [:index, :create]

    # GET /downloads
    #
    # Affiche la liste des téléchargements en cours
    # Affiche le formulaire de téléchargement
    def index
      respond_to do |format|
        format.html
        format.json
      end
    end

    # POST /downloads
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

    # DELETE /download/:id
    #
    # Efface un téléchargement
    def destroy
      @download.destroy!
      redirect_to action: :index, status: 303
    end

    # :GET /downloads/events
    #
    # Retourne la progression des téléchargements
    def events
      response.headers['Content-Type'] = 'text/event-stream'
      sse_progress = SSE.new response.stream, retry: 3, event: 'download-progress'
      sse_new = SSE.new response.stream, retry: 3, event: 'download-new'

      Download.send_events sse_progress, sse_new
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
