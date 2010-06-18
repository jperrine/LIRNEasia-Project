class UsageLevelsController < ApplicationController
  before_filter :get_logged_in_user
  
  def index
    @usage_levels = UsageLevel.all
  end
  
  def new
    @usage_level = UsageLevel.new
  end
  
  def create 
    @usage_level = UsageLevel.new(params[:usage_level])
    if @usage_level.save
      flash[:notice] = "Usage level was successfully created."
      redirect_to @usage_level
    else
      flash[:notice] = "There was an error creating the usage level."
      render :action => 'new'
    end
  end
  
  def edit
    @usage_level = UsageLevel.find(params[:id])
  end
  
  def update
    @usage_level = UsageLevel.find(params[:id])
    
    if @usage_level.update_attributes(params[:usage_level])
      flash[:notice] = "Usage level has successfully been updated."
      redirect_to @usage_level
    else
      flash[:notice] = "There was an error updating the usage level, please try again."
      render :action => 'edit'
    end
  end
  
  def destroy 
    @usage_level = UsageLevel.find(params[:id])
    if @usage_level.destroy
      flash[:notice] = "Usage level was deleted successfully."
      redirect_to :action => 'index'
    else
      flash[:notice] = "There was an error deleting the usage level, please try again."
      redirect_to :action => 'index'
    end
  end
  
  def show
    @usage_level = UsageLevel.find(params[:id])
  end
end
