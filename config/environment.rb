# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.5' unless defined? RAILS_GEM_VERSION
# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.gem 'radar-delayed_job', :lib => "delayed_job", :version => "1.7.1"
  config.gem 'json'
  config.gem 'popen4'
  config.gem 'nokogiri', :version => ">= 1.3.2"
  config.gem 'SystemTimer', :lib => "system_timer" # see http://ph7spot.com/articles/system_timer
  config.gem 'grit'
  config.time_zone = 'UTC'
end

CONSTRUCT = YAML::load_file("#{RAILS_ROOT}/config/construct.yml")[RAILS_ENV]