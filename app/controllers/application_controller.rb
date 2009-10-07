# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  
  before_filter :authenticate
  def authenticate
    if CONSTRUCTA["user"] && CONSTRUCTA["password"]
      authenticate_or_request_with_http_basic do |user, password|
        CONSTRUCTA["user"] == user && CONSTRUCTA["password"] == password
      end
    end
  end
  
  # rescue_from ActiveRecord::RecordNotFound do
  #   render :status => 404
  # end
  
end
