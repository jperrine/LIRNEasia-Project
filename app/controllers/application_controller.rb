class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :username
  
  #all controllers will inherit this method so it doesn't need to be maintained across 
  #multiple controllers, if any logic were to be changed
  def get_logged_in_user
    id = session[:user_id]
    unless id
      flash[:notice] = "You must log in first."
      redirect_to :controller => "user", :action => "log_in"
    else
      @logged_in_user = User.find(id)
    end
  end
end
