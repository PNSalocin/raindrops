module Raindrops
  # Modèle identifiant un gestionnaire de téléchargements
  class DownloadManager
    include ActionView::Helpers

    # Gestion des évènements liés aux téléchargements (progression, ajout, suppression, complétion).
    # Un heartbeat est envoyé périodiquement pour s'assurer de la présence du client.
    #
    # @param [SSE] sse Classe d'écriture des SSE
    # @param [Array] events Evènements de communication.
    #   @option events [Symbol] :progress Notifications de progression de téléchargement
    #   @option events [Symbol] :created Notifications de création de téléchargement
    #   @option events [Symbol] :destroyed Notifications de suppression de téléchargement
    #   @option events [Symbol] :completed Notifications de complétion de téléchargement
    # @param [Integer] iterations (optionnel) Nombre de fois ou la boucle de gestion d'évènements est effectuée
    def send_events(sse, events, iterations = nil)
      downloads = { old: Raindrops::Download.all.index_by(&:id), new: Raindrops::Download.all.index_by(&:id) }
      @sse = sse

      if iterations
        iterations.times do
          downloads = manage_events downloads, events
        end
      else
        loop do
          downloads = manage_events downloads, events
        end
      end
    end

    private

    # Gestion des évènements liés aux téléchargements (progression, ajout, suppression, complétion).
    # Un heartbeat est envoyé périodiquement pour s'assurer de la présence du client.
    #
    # @param [Array] downloads Etat des anciens et des nouveaux téléchargements
    # @return [Hash] Etat des anciens et des nouveaux téléchargements après envoi des évènements
    def manage_events(downloads, events)
      send_heartbeat
      send_created_events(downloads[:new], downloads[:old]) if events.include? :created
      send_destroyed_events(downloads[:new], downloads[:old]) if events.include? :destroyed
      send_completed_events(downloads[:new], downloads[:old]) if events.include? :completed

      20.times do
        if events.include? :progress
          downloads[:new].each do |_download_id, download|
            send_progress_events download
          end
        end

        sleep 0.5
      end

      # Un clean cache est nécessaire ici, sinon rails continue a resservir les résultats du cache,
      # et donc ne voit pas les nouveaux téléchargements
      ActiveRecord::Base.connection.query_cache.clear
      { old: downloads[:new], new: Raindrops::Download.all.index_by(&:id) }
    end

    # Envoie un heartbeat pour s'assurer que le client est toujours à l'écoute des notifications
    def send_heartbeat
      @sse.write :heartbeat
    end

    # Envoie les évènements associés à la création d'un téléchargement
    #
    # @param [Array] downloads Etat actuel des téléchargements
    # @param [Array] old_downloads Ancien état des téléchargements
    def send_created_events(downloads, old_downloads)
      downloads.except(*old_downloads.keys).each do |_created_download_id, created_download|
        extra_attributes = { file_size_human: number_to_human_size(created_download.file_size) }
        attributes = created_download.attributes.merge extra_attributes
        @sse.write(attributes, event: 'download-created')
      end
    end

    # Envoie les évènements associés à la suppression d'un téléchargement
    #
    # @param [Array] downloads Etat actuel des téléchargements
    # @param [Array] old_downloads Ancien état des téléchargements
    def send_destroyed_events(downloads, old_downloads)
      old_downloads.except(*downloads.keys).each do |destroyed_download_id, _destroyed_download|
        @sse.write({ id: destroyed_download_id }, event: 'download-destroyed')
      end
    end

    # Envoie les évènements associés à la progression d'un téléchargement
    #
    # @param [Download] download Téléchargement dont la progression est à notifier
    def send_progress_events(download)
      return unless download.downloading?

      @sse.write({ id: download.id, progress: download.progress, bytes_downloaded: download.bytes_downloaded,
                   bytes_downloaded_human: number_to_human_size(download.bytes_downloaded),
                   file_size_human: number_to_human_size(download.file_size) }, event: 'download-progress')
    end

    # Envoie les évènements associés à la complétion d'un téléchargement
    #
    # @param [Array] downloads Etat actuel des téléchargements
    # @param [Array] old_downloads Ancien état des téléchargements
    def send_completed_events(downloads, old_downloads)
      downloads.each do |_download_id, download|
        old_download = old_downloads[download.id]
        next if !old_download || !old_download.downloading? || !download.completed?

        @sse.write({ id: download.id }, event: 'download-completed')
      end
    end
  end
end
