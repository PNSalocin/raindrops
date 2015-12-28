module Raindrops
  module Download
    # Canal associé aux nouveaux téléchargements
    class Progressed < Raindrops::ApplicationCable::Channel
      # Rebroadcast des messages envoyés par les appelants
      def subscribed
        stream_from 'download_created'
      end
    end
  end
end
