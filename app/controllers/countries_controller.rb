class CountriesController < ApplicationController
  before_filter :get_logged_in_user, :except => [:index, :show]
  before_filter :authorize_user, :only => [:new, :edit, :update, :destroy]

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
    @fixed_providers = @country.providers.select { |p| p.provider_type == "Fixed" }
    @mobile_providers = @country.providers.select { |p| p.provider_type == "Mobile" }
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