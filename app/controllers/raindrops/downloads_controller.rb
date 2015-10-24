module Raindrops
  class DownloadsController < ApplicationController

    before_action :set_downloads, only: [:index]

    def index

    end

    def create
      # http://ipv4.download.thinkbroadband.com/50MB.zip
      download = Raindrops::Download.new source_url: 'http://ipv4.download.thinkbroadband.com/50MB.zip',
                                         destination_path: "/home/nicolas/Bureau/#{SecureRandom.hex}.zip"
      download.save
      download.delay.start
    end

    private

    def set_downloads
      @downloads = Raindrops::Download.all
    end

  end
end
