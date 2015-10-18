module Raindrops
  class HomeController < ActionController::Base

    def index
      download = Raindrops::Download.new source_url: 'http://ipv4.download.thinkbroadband.com/10MB.zip',
                                         destination_path: "/home/nicolas/Bureau/#{SecureRandom.hex}.zip"
      download.save
      download.delay.start
    end

  end
end
