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

  s.add_development_dependency 'haml-rails', '~> 0.9.0'
  s.add_development_dependency 'rubocop', '~> 0.35.1'
  s.add_development_dependency 'yard', '~> 0.8.7'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 0.4.8'
  s.add_development_dependency 'brakeman', '~> 3.1.2'

  # Tests
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'factory_girl_rails'

  # Core
  s.add_dependency 'rails', '~> 4.2.5'
  s.add_dependency 'delayed_job_active_record', '~> 4.1.0'
  s.add_dependency 'puma', '~> 2.15.3'

  # DB
  s.add_dependency 'sqlite3', '~> 1.3.11'

  # Vues
  s.add_dependency 'haml', '~> 4.0.7'
  s.add_dependency 'jquery-rails', '~> 4.0.5'
  s.add_dependency 'bootstrap-sass', '~> 3.3.5'
  s.add_dependency 'sass-rails', '>= 3.2'
  s.add_dependency 'coffee-rails'
end
