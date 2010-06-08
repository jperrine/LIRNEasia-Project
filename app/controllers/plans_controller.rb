class PlansController < ApplicationController
  before_filter :get_logged_in_user, :except => [:index, :show]
  
  # GET /countries/1/providers/1/plans
  # redirects to provider's show action
  def index
    redirect_to :controller => 'providers', :action => 'show', :id => params[:provider_id]
  end

  # GET /countries/1/providers/1/plans/new
  def new
    @country = Country.find(params[:country_id])
    @provider = Provider.find(params[:provider_id])
    @plan = Plan.new
  end
  
  # POST /countries/1/providers/1/plans/create
  def create
    @country = Country.find(params[:country_id])
    @provider = Provider.find(params[:provider_id])
    @plan = Plan.new(params[:plan])
    @plan.provider = @provider
    
    if @plan.save
      flash[:notice] = "Plan successfully created."
      redirect_to :action => 'index'
    else
      render :action => 'new'
    end
  end
  
  # GET /countries/1/providers/1/plans/1/edit
  def edit
    @country = Country.find(params[:country_id])
    @provider = Provider.find(params[:provider_id])
    @plan = Plan.find(params[:id])
  end
  
  # POST /countries/1/providers/1/plans/1/update
  def update
    @country = Country.find(params[:country_id])
    @provider = Provider.find(params[:provider_id])
    @plan = Plan.find(params[:id])
    
    if @plan.update_attributes(params[:plan])
      flash[:notice] = "Plan successfully updated."
      redirect_to :action => 'index'
    else
      render :action => 'edit'
    end
  end
  
  # DELETE /countries/1/providers/1/plans/1/destroy
  def destroy
    @country = Country.find(params[:country_id])
    @provider = Provider.find(params[:provider_id])
    @plan = Plan.find(params[:id])
    @plan.destroy
    redirect_to :action => 'index'
  end
  
  # GETS /countries/1/providers/1/plans/1
  def show
    @country = Country.find(params[:country_id])
    @provider = Provider.find(params[:provider_id])
    @plan = Plan.find(params[:id])
  end
  
end