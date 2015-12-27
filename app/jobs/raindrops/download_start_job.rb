module Raindrops
  # Gère le lancement des téléchargements
  class DownloadStartJob < ApplicationJob
    queue_as :default

    # Lance le téléchargement du premier téléchargement passé en paramètre
    def perform(*downloads)
      downloads.first.start
    end
  end
end
