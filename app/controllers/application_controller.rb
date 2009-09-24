# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  before_filter :authenticate
  def authenticate
    authenticate_or_request_with_http_basic do |user, password|
      AUTH["user"] == user && AUTH["password"] == password
    end
  end
  
end
