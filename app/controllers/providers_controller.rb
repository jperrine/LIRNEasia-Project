class ProvidersController < ApplicationController
  before_filter :get_logged_in_user, :except => [:index, :show]
  before_filter :only => [:edit, :update, :destroy, :create] do |controller| controller.authorize_user end
  
  # GET /countries/1/providers
  #since all providers are displayed in /countries/1, redirect there
  def index
    redirect_to :controller => 'countries', :action => 'show', :id => params[:country_id]
  end
  
  # GET /countries/1/providers/1
  def show
    @provider = Provider.find(params[:id])
    @country = Country.find(params[:country_id])
  end
  
  # GET /countries/1/providers/new
  def new
    @provider = Provider.new
    @country = Country.find(params[:country_id])
  end
  
  # POST /countries/1/providers/create
  def create
    @country = Country.find(params[:country_id])
    @provider = @country.providers.build(params[:provider])
    if @provider.save
      flash[:notice] = "Provider successfully created."
      redirect_to :action => 'show', :id => @provider.id
    else
      render :action => 'new'
    end
  end
  
  # GET /countries/1/providers/1/edit
  def edit
    @country = Country.find(params[:country_id])
    @provider = Provider.find(params[:id])
  end
  
  # POST /countries/1/providers/1/update
  def update
    #@country = Country.find(params[:country_id])
    @provider = Provider.find(params[:id])
    if @provider.update_attributes(params[:provider])
      flash[:notice] = "Provider successfully updated."
      redirect_to :controller => 'countries', :action => 'show', :id => params[:country_id]
    else
      render :action => 'edit'    
    end
  end
  
  # DELETE /countries/1/providers/1/delete
  def destroy
    @provider = Provider.find(params[:id])
    @provider.destroy
    redirect_to :action => 'index'
  end

end