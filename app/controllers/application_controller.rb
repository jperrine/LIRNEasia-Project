class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  
  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :username
  
  before_filter :set_current_user
  
  #all controllers will inherit this method so it doesn't need to be maintained across 
  #multiple controllers, if any logic were to be changed
  def get_logged_in_user
    id = session[:user_id]
    unless id
      flash[:notice] = "You must log in first."
      redirect_to :controller => "user", :action => "log_in"
    else
      @logged_in_user ||= User.find_by_id(id)
    end
  end
  
  def set_current_user
    @logged_in_user ||= User.find_by_id(session[:user_id])
  end
  
  def authorize_user
    unless @logged_in_user.country_id.nil? ? true : (params[:country_id] || params[:id]) == @logged_in_user.country_id.to_s
      flash[:error] = "You're not allowed to access that"
      redirect_to root_url
    end
  end
end
