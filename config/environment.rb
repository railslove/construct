# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION
# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'tobi-delayed_job', :lib => "delayed_job"
  config.gem 'json'
  config.gem 'popen4'
  config.time_zone = 'UTC'
end

AUTH = YAML::load_file("#{RAILS_ROOT}/config/auth.yml")[RAILS_ENV]
CONSTRUCTA = YAML::load_file("#{RAILS_ROOT}/config/constructa.yml")[RAILS_ENV]