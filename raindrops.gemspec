$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "raindrops/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "raindrops"
  s.version     = Raindrops::VERSION
  s.authors     = ["PNSalocin"]
  s.email       = ["nicolas.merelli@gmail.com"]
  s.homepage    = "https://github.com/PNSalocin/raindrops"
  s.summary     = "HTTP Download manager."
  s.description = "HTTP Download manager with both graphical and console UI."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  # CI
  s.add_development_dependency 'codeclimate-test-reporter'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'brakeman'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'yard'

  # Core
  s.add_dependency 'active_model_serializers', '>= 0.10.0.rc3'
  #s.add_dependency 'delayed_job_active_record', '~> 4.1.0'
  s.add_dependency 'rails'
  s.add_dependency 'puma'

  # DB
  s.add_dependency 'sqlite3'
end
