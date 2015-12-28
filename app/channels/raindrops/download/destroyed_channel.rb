module Raindrops
  module Download
    # Canal associé aux téléchargements supprimés
    class Destroyed < Raindrops::ApplicationCable::Channel
      # Rebroadcast des messages envoyés par les appelants
      def subscribed
        stream_from 'download_destroyed'
      end
    end
  end
end
