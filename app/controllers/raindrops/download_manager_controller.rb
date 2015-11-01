module Raindrops
  # Controlleur de gestion des évènements associés aux téléchargements
  class DownloadManagerController < ApplicationController
    include ActionController::Live

    # :GET /downloads/events
    #
    # Envoie les différentes notifications associées aux téléchargements
    def events
      response.headers['Content-Type'] = 'text/event-stream'

      begin
        sse = SSE.new response.stream
        download_manager = Raindrops::DownloadManager.new
        download_manager.send_events sse, [:progress, :created, :destroyed, :completed]
      rescue ActionController::Live::ClientDisconnected
        # Les deconnexions des clients envoient une exception, rien de spécial à faire ici
        puts "Client @#{request.remote_ip} disconnected."
      ensure
        sse.close
      end
    end
  end
end
