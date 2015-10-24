module Raindrops
  class Engine < ::Rails::Engine
    isolate_namespace Raindrops

    initializer "raindrops.assets.precompile" do |app|
      app.config.i18n.load_path += Dir["#{config.root}/config/locales/raindrops/*.yml"]
      app.config.i18n.default_locale = :fr

      app.config.assets.precompile += %w(raindrops/application.css, raindrops/application.js)
    end
  end
end
