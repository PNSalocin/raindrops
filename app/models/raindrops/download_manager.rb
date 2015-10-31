require 'singleton'

module Raindrops
  # Modèle identifiant un gestionnaire de téléchargements
  class DownloadManager
    include Singleton

    # BOUCLE INFINIE
    # Gestion de évènements liés aux téléchargements (progression, ajout)
    #
    # *Params* :
    # - _Hash_ +sse_channels+ Canaux de communication SSE. Les canaux possibles sont :
    #   - :progress  : Notifications de progression de téléchargement
    #   - :created   : Notifications de création de téléchargement
    #   - :destroyed : Notifications de suppression de téléchargement
    def send_events(sse_channels)
      downloads = Raindrops::Download.all.index_by(&:id)
      old_downloads = downloads

      loop do
        send_created_events(downloads, old_downloads, sse_channels[:created]) if sse_channels[:created]
        send_destroyed_events(downloads, old_downloads, sse_channels[:destroyed]) if sse_channels[:destroyed]

        10.times do
          if sse_channels[:progress] || sse_channels[:completed]
            downloads.each do |_download_id, download|
              send_progress_events(download, sse_channels[:progress]) if sse_channels[:progress]
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
      created_downloads = downloads.except(*old_downloads.keys)
      created_downloads.each do |_created_download_id, created_download|
        sse_created.write created_download.attributes
      end
    end

    # Envoie les évènements associés à la suppression d'un téléchargement
    #
    # *Params*
    # - _Array_ +downloads+ : Etat actuel des téléchargements
    # - _Array_ +old_downloads+ : Ancien état des téléchargements
    # - _SSE_ +sse_destroyed+ : Canal SSE des notifications de suppression
    def send_destroyed_events(downloads, old_downloads, sse_destroyed)
      destroyed_downloads = old_downloads.except(*downloads.keys)
      destroyed_downloads.each do |destroyed_download_id|
        sse_destroyed.write id: destroyed_download_id
      end
    end

    # Envoie les évènements associés à la progression d'un téléchargement
    #
    # *Params*
    # - _Download_ +download+ : Téléchargement dont la progression est à notifier
    # - _SSE_ +sse_progress+ : Canal SSE des notifications de progression
    def send_progress_events(download, sse_progress)
      return unless download.status == Raindrops::Download.statuses[:downloading]

      sse_progress.write id: download.id, progress: download.progress
      sse_progress.write id: download.id, progress: download.progress
    end
  end
end
