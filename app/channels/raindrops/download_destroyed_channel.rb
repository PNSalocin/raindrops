# Canal associé aux téléchargements supprimés
class DownloadDestroyedChannel < ApplicationCable::Channel
  # Rebroadcast des messages envoyés par les appelants
  def subscribed
    stream_from 'download_destroyed'
  end
end
