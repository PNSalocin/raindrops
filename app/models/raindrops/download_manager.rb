require 'singleton'

module Raindrops
  # Modèle identifiant un gestionnaire de téléchargements
  class DownloadManager
    include Singleton
    include ActionView::Helpers

    # BOUCLE INFINIE
    # Gestion de évènements liés aux téléchargements (progression, ajout)
    #
    # *Params* :
    # - _Hash_ +sse_channels+ Canaux de communication SSE. Les canaux possibles sont :
    #   - :progress  : Notifications de progression de téléchargement
    #   - :created   : Notifications de création de téléchargement
    #   - :destroyed : Notifications de suppression de téléchargement
    #   - :completed : Notifications de complétion de téléchargement
    def send_events(sse_channels)
      downloads = Raindrops::Download.all.index_by(&:id)
      old_downloads = downloads

      loop do
        send_created_events(downloads, old_downloads, sse_channels[:created]) if sse_channels[:created]
        send_destroyed_events(downloads, old_downloads, sse_channels[:destroyed]) if sse_channels[:destroyed]
        send_completed_events(downloads, old_downloads, sse_channels[:completed]) if sse_channels[:completed]

        10.times do
          if sse_channels[:progress]
            downloads.each do |_download_id, download|
              send_progress_events(download, sse_channels[:progress])
            end
          end

          sleep 1
        end

        # Un clean cache est nécessaire ici, sinon rails continue a resservir les résultats du cache,
        # et donc ne voit pas les nouveaux téléchargements
        ActiveRecord::Base.connection.query_cache.clear
        old_downloads = downloads
        downloads = Raindrops::Download.all.index_by(&:id)
      end
    end

    private

    # Envoie les évènements associés à la création d'un téléchargement
    #
    # *Params*
    # - _Array_ +downloads+ : Etat actuel des téléchargements
    # - _Array_ +old_downloads+ : Ancien état des téléchargements
    # - _SSE_ +sse_created+ : Canal SSE des notifications de création
    def send_created_events(downloads, old_downloads, sse_created)
      downloads.except(*old_downloads.keys).each do |_created_download_id, created_download|
        extra_attributes = { file_size_human: number_to_human_size(created_download.file_size) }
        attributes = created_download.attributes.merge extra_attributes
        sse_created.write attributes
      end
    end

    # Envoie les évènements associés à la suppression d'un téléchargement
    #
    # *Params*
    # - _Array_ +downloads+ : Etat actuel des téléchargements
    # - _Array_ +old_downloads+ : Ancien état des téléchargements
    # - _SSE_ +sse_destroyed+ : Canal SSE des notifications de suppression
    def send_destroyed_events(downloads, old_downloads, sse_destroyed)
      old_downloads.except(*downloads.keys).each do |destroyed_download_id, _destroyed_download|
        sse_destroyed.write id: destroyed_download_id
      end
    end

    # Envoie les évènements associés à la progression d'un téléchargement
    #
    # *Params*
    # - _Download_ +download+ : Téléchargement dont la progression est à notifier
    # - _SSE_ +sse_progress+ : Canal SSE des notifications de progression
    def send_progress_events(download, sse_progress)
      return unless download.downloading?

      sse_progress.write id: download.id, progress: download.progress, bytes_downloaded: download.bytes_downloaded,
                         bytes_downloaded_human: number_to_human_size(download.bytes_downloaded),
                         file_size_human: number_to_human_size(download.file_size)
    end

    # Envoie les évènements associés à la complétion d'un téléchargement
    #
    # *Params*
    # - _Array_ +downloads+ : Etat actuel des téléchargements
    # - _Array_ +old_downloads+ : Ancien état des téléchargements
    # - _SSE_ +sse_completed+ : Canal SSE des notifications de complétion
    def send_completed_events(downloads, old_downloads, sse_completed)
      downloads.each do |_download_id, download|
        old_download = old_downloads[download.id]
        next if !old_download || !old_download.downloading? || !download.completed?

        sse_completed.write id: download.id
      end
    end
  end
end
