class CountriesController < ApplicationController
  before_filter :get_logged_in_user, :except => [:index, :show]

  # GET /countries/new
  def new
    @country = Country.new
  end
  
  # POST /countries/create
  def create
    @country = Country.new(params[:country])
    if @country.save
      flash[:notice] = "Country successfully created."
      redirect_to countries_path
    else
      render :action => 'new'
    end
  end
  
  # GET /countries
  def index
    @countries = Country.all
  end
  
  # GET /countries/1
  def show
    @country = Country.find(params[:id])
    #@fixed_providers, @mobile_providers = [],[]
    @fixed_providers = Provider.find(:all,
      :conditions => ["country_id = ? AND provider_type = ?", @country.id, "fixed"])
    @mobile_providers = Provider.find(:all,
      :conditions => ["country_id = ? AND provider_type = ?", @country.id, "mobile"])
    #@country.providers.each do |p| 
      #@fixed_providers << p if p.provider_type == "fixed"
      #@mobile_providers << p if p.provider_type == "mobile"
    #end
  end
  
  # GET /countries/1/edit
  def edit
    @country = Country.find(params[:id])
  end
  
  # POST /countries/1/update
  def update
    @country = Country.find(params[:id])
    if @country.update_attributes(params[:country])
      flash[:notice] = "Country was successfully updated."
      redirect_to :action => 'show', :id => @country.id
    else
      render :action => 'edit'
    end
  end
  
  # DELETE /countries/1/
  def destroy
    @country = Country.find(params[:id])
    @country.destroy
    redirect_to :action => 'index'
  end
  
end