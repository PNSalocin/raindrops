$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "raindrops/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "raindrops"
  s.version     = Raindrops::VERSION
  s.authors     = [""]
  s.email       = [""]
  s.homepage    = ""
  s.summary     = "Summary of Raindrops."
  s.description = "Description of Raindrops."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_development_dependency 'haml-rails', '~> 0.9'

  s.add_dependency 'rails', '~> 4.2.4'
  s.add_dependency 'haml', '~> 4.0.7'

  s.add_dependency 'delayed_job_active_record'
  s.add_dependency 'sqlite3', '~> 1.3.11'
end
