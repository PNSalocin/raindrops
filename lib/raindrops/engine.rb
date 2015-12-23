module Raindrops
  class Engine < ::Rails::Engine
    isolate_namespace Raindrops
    config.generators.api_only = true

    # Inclusion implicite des gems utilisés dans l'engine
    require 'active_model_serializers'
  end
end
