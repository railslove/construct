class PeopleController < ApplicationController
  def login
    if request.post?
      if Person.authenticated?(params[:name], params[:password])
        flash[:notice] = "You have successfully logged in."
        redirect_to projects_path
      else
        flash[:error] = "Could not log you in. Please try again."
      end
    end
  end

  def logout
  end

end
