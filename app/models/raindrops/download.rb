module Raindrops
  class Download < ActiveRecord::Base

    def start
      require 'net/http'
      Net::HTTP.new(source_uri.host, source_uri.port).request_get(source_uri.path) do |response|

        file_size = response.header['Content-Length'].to_i

        puts "File found @#{source_uri}."
        puts "File size: #{file_size}."

        puts "Opening destination file @#{destination_path}."
        file = ::File.open(destination_path, "wb")
        puts 'Destination file opened.'

        bytes_downloaded = 0
        old_percent_downloaded = 0
        puts 'Starting download'

        response.read_body do |chunk|
          bytes_downloaded += chunk.length
          percent_downloaded = (bytes_downloaded * 100) / file_size

          if percent_downloaded != old_percent_downloaded
            puts "#{percent_downloaded}/100% downloaded."
          end

          old_percent_downloaded = percent_downloaded


          file.write chunk
        end
        puts 'STOP DOWNLOAD'
      end
    end

    private

    def source_uri
      @source_uri = URI(source_url) unless @source_uri
      @source_uri
    end

  end
end