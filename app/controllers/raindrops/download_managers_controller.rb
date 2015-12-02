module Raindrops
  # Controlleur de gestion des évènements associés aux téléchargements
  class DownloadManagersController < ApplicationController
    include ActionController::Live

    # Envoie les différentes notifications associées aux téléchargements.
    #
    # @route /downloads/events
    def events
      response.headers['Content-Type'] = 'text/event-stream'

      begin
        sse = SSE.new response.stream
        download_manager = Raindrops::DownloadManager.new sse
        download_manager.send_events
      rescue ActionController::Live::ClientDisconnected
        # Les deconnexions des clients envoient une exception, rien de spécial à faire ici
        Rails.logger "Client @#{request.remote_ip} disconnected."
      ensure
        sse.close
      end
    end
  end
end
