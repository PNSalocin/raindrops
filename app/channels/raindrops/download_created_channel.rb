# Canal associé aux nouveaux téléchargements
class DownloadCreatedChannel < ApplicationCable::Channel
  # Rebroadcast des messages envoyés par les appelants
  def subscribed
    stream_from 'download_created'
  end
end
