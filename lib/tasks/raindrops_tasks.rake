# desc "Explaining what the task does"
# task :raindrops do
#   # Task goes here
# end

task :testdl do
  require 'net/http'
  require 'uri'

  url = "http://ipv4.download.thinkbroadband.com/5MB.zip"

  #Thread.new do
    thread = Thread.current
    body = thread[:body] = []

    url = URI.parse url
    Net::HTTP.new(url.host, url.port).request_get(url.path) do |response|
      length = thread[:length] = response['Content-Length'].to_i

      response.read_body do |fragment|
        body << fragment
        thread[:done] = (thread[:done] || 0) + fragment.length
        thread[:progress] = thread[:done].quo(length) * 100

        File.open('/home/nicolas/Bureau/5MB.zip', "w:#{encoding.name}") do |file|
          file.write response.body
        end
      end
    end
  #end
end