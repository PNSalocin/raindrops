module Raindrops
  class Engine < ::Rails::Engine
    isolate_namespace Raindrops
    config.generators.api_only = true

    config.active_job.queue_adapter = :sidekiq

    # Inclusion implicite des modules utilisés par l'engine
    require 'active_model_serializers'
    require 'sidekiq/api'
  end
end
