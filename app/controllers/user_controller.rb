require 'digest/sha1'
class UserController < ApplicationController
  before_filter :get_logged_in_user, :except => [:log_in, :do_login]
  
  def index
    redirect_to :action => 'log_in'
  end
  
  def create
    @user = User.new(params[:user])
    @user.password = hash_password(@user.password)
    @user.password_confirmation = hash_password(@user.password_confirmation)
    if @user.save
      flash[:notice] = "Administrator created."
      redirect_to :action => 'log_in'
    else
      render :action => 'new'
    end
  end

  def log_in
  end

  def do_login
    username = params[:username]
    password = params[:password]
    hashed_password = hash_password(password)
    @user = User.find_by_username(username)
    unless @user.nil?
      if @user.password == hashed_password
        session[:user_id] = @user.id
        redirect_to :controller => 'countries'
      else
        flash[:error] = "Incorrect password."
        redirect_to :action => 'log_in'
      end
    else
      flash[:error] = "Unknown user."
      redirect_to :action => 'log_in'
    end
  end

  def log_out
    session[:user_id] = nil
  end

  def new
    @user = User.new
  end
  
  private
  def hash_password(password)
    Digest::SHA1.hexdigest(password)
  end
end
