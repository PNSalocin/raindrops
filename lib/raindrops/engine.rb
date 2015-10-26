module Raindrops
  class Engine < ::Rails::Engine
    isolate_namespace Raindrops

    initializer 'raindrops' do |app|
      app.config.assets.precompile += %w(raindrops/application.css, raindrops/application.js)

      app.config.cache_store = :memory_store, { size: 8.megabytes }

      app.config.i18n.load_path += Dir["#{config.root}/config/locales/raindrops/*.yml"]
      app.config.i18n.default_locale = :fr
    end
  end
end
