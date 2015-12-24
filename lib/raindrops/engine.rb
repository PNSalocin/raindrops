module Raindrops
  class Engine < ::Rails::Engine
    isolate_namespace Raindrops
    config.generators.api_only = true

    config.active_job.queue_adapter = :sidekiq
  end
end
