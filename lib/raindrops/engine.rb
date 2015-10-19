module Raindrops
  class Engine < ::Rails::Engine
    isolate_namespace Raindrops

    initializer "raindrops.assets.precompile" do |app|
      app.config.assets.precompile += %w(raindrops/application.css, raindrops/application.js)
    end
  end
end
