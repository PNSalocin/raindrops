module Raindrops #:nodoc:
  class Engine < ::Rails::Engine #:nodoc:
    isolate_namespace Raindrops

    require 'haml'
    require 'bootstrap-sass'
    require 'jquery-rails'
    require 'bootstrap-sass'
    require 'sass-rails'
	require 'coffee-rails'

    initializer 'raindrops' do |app|
      app.config.cache_store = :memory_store, { size: 8.megabytes }
      # Nécessaire pour PUMA pour paralleliser les appels
      # *see* http://guides.rubyonrails.org/v3.2.21/configuring.html (3.1)
      app.config.allow_concurrency = true

      app.config.i18n.load_path += Dir["#{config.root}/config/locales/raindrops/*.yml"]
      app.config.i18n.default_locale = :fr

      app.config.assets.precompile += %w(raindrops/application.css, raindrops/application.js)
    end

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
