require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'raindrops'
Dir["./spec/support/**/*.rb"].sort.each { |f| require f}