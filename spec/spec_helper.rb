# This file is copied to ~/spec when you run 'ruby script/generate rspec'
# from the project root directory.
ENV["RAILS_ENV"] ||= 'test'
require File.dirname(__FILE__) + "/../config/environment" unless defined?(RAILS_ROOT)
require 'spec/autorun'
require 'spec/rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

Spec::Runner.configure do |config|
  config.use_transactional_fixtures = true
  config.use_instantiated_fixtures  = false
  config.fixture_path               = RAILS_ROOT + '/spec/fixtures/'
  config.mock_with :mocha
end

FileUtils.rm_r("#{RAILS_ROOT}/tmp/builds/") rescue nil
FileUtils.mkdir_p("#{RAILS_ROOT}/tmp/builds")


require File.dirname(__FILE__) + "/blueprints"

def payload(key)
  File.read("#{RAILS_ROOT}/spec/fixtures/#{key}")
end

# Print the location of puts/p calls so you can find them later
def puts str
  super caller.first
  super str
end

def p obj
  puts caller.first
  super obj
end
