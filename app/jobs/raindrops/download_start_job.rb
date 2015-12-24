module Raindrops
  # Gère le lancement des téléchargements
  class DownloadStartJob < ApplicationJob
    queue_as :default

    def perform(*downloads)
      downloads.first.start
    end
  end
end
