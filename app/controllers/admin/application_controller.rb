class Admin::ApplicationController < ApplicationController
  before_filter :login_required
  before_filter :ensure_admin
  
  def login_required
    if !Person.find_by_id(session[:id])
      session[:return_to] = request.request_uri
      flash[:error] = "You must be logged in access this area."
      redirect_to login_path
    end
  end

end