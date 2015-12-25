module Raindrops
  class Engine < ::Rails::Engine
    isolate_namespace Raindrops
    config.generators.api_only = true

    config.active_job.queue_adapter = :sidekiq

    # Inclusion implicite des modules utilisés par l'engine
    require 'active_model_serializers'
    require 'sidekiq/api'

    initializer 'raindrops' do |app|
      app.config.cache_store = :memory_store, { size: 8.megabytes }

      app.config.i18n.load_path += Dir["#{config.root}/config/locales/raindrops/*.yml"]
      app.config.i18n.default_locale = :fr
    end

    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
