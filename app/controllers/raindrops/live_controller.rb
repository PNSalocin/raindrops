module Raindrops
  class LiveController < ActionController::Base
    include ActionController::Live

    def downloads_progress
      begin
        response.headers['Content-Type'] = 'text/event-stream'
        sse = SSE.new(response.stream, retry: 300, event: "event-name")
        100.times do
          sse.write({ name: 'test'})
          sleep 1
        end
      ensure
        sse.close
      end
    end
  end
end