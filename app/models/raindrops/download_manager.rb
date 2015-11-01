module Raindrops
  # Modèle identifiant un gestionnaire de téléchargements
  class DownloadManager
    include ActionView::Helpers

    # BOUCLE INFINIE
    # Gestion de évènements liés aux téléchargements (progression, ajout, suppression, complétion)
    # Un heartbeat est envoyé périodiquement pour s'assurer de la présence du client
    #
    # *Params* :
    # - _SSE_ +sse+ Classe d'écriture des SSE
    # - _Array_ +events+ : Evènements de communication. Ceux-ci peuvent-être :
    #   - :progress  : Notifications de progression de téléchargement
    #   - :created   : Notifications de création de téléchargement
    #   - :destroyed : Notifications de suppression de téléchargement
    #   - :completed : Notifications de complétion de téléchargement
    def send_events(sse, events)
      @sse = sse
      downloads = Raindrops::Download.all.index_by(&:id)
      old_downloads = downloads

      loop do
        send_heartbeat
        send_created_events(downloads, old_downloads) if events.include? :created
        send_destroyed_events(downloads, old_downloads) if events.include? :destroyed
        send_completed_events(downloads, old_downloads) if events.include? :completed

        20.times do
          if events.include? :progress
            downloads.each do |_download_id, download|
              send_progress_events download
            end
          end

          sleep 0.5
        end

        # Un clean cache est nécessaire ici, sinon rails continue a resservir les résultats du cache,
        # et donc ne voit pas les nouveaux téléchargements
        ActiveRecord::Base.connection.query_cache.clear
        old_downloads = downloads
        downloads = Raindrops::Download.all.index_by(&:id)
      end
    end

    private

    # Envoie un heartbeat pour s'assurer que le client est toujours à l'écoute des notifications
    def send_heartbeat
      @sse.write :heartbeat
    end

    # Envoie les évènements associés à la création d'un téléchargement
    #
    # *Params*
    # - _Array_ +downloads+ : Etat actuel des téléchargements
    # - _Array_ +old_downloads+ : Ancien état des téléchargements
    def send_created_events(downloads, old_downloads)
      downloads.except(*old_downloads.keys).each do |_created_download_id, created_download|
        extra_attributes = { file_size_human: number_to_human_size(created_download.file_size) }
        attributes = created_download.attributes.merge extra_attributes
        @sse.write(attributes, event: 'download-created')
      end
    end

    # Envoie les évènements associés à la suppression d'un téléchargement
    #
    # *Params*
    # - _Array_ +downloads+ : Etat actuel des téléchargements
    # - _Array_ +old_downloads+ : Ancien état des téléchargements
    def send_destroyed_events(downloads, old_downloads)
      old_downloads.except(*downloads.keys).each do |destroyed_download_id, _destroyed_download|
        @sse.write({ id: destroyed_download_id }, event: 'download-destroyed')
      end
    end

    # Envoie les évènements associés à la progression d'un téléchargement
    #
    # *Params*
    # - _Download_ +download+ : Téléchargement dont la progression est à notifier
    def send_progress_events(download)
      return unless download.downloading?

      @sse.write({ id: download.id, progress: download.progress, bytes_downloaded: download.bytes_downloaded,
                   bytes_downloaded_human: number_to_human_size(download.bytes_downloaded),
                   file_size_human: number_to_human_size(download.file_size) }, event: 'download-progress')
    end

    # Envoie les évènements associés à la complétion d'un téléchargement
    #
    # *Params*
    # - _Array_ +downloads+ : Etat actuel des téléchargements
    # - _Array_ +old_downloads+ : Ancien état des téléchargements
    def send_completed_events(downloads, old_downloads)
      downloads.each do |_download_id, download|
        old_download = old_downloads[download.id]
        next if !old_download || !old_download.downloading? || !download.completed?

        @sse.write({ id: download.id }, event: 'download-completed')
      end
    end
  end
end
