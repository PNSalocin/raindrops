# Canal associé aux téléchargements terminés
class DownloadCompletedChannel < ApplicationCable::Channel
  # Rebroadcast des messages envoyés par les appelants
  def subscribed
    stream_from 'download_completed'
  end
end
