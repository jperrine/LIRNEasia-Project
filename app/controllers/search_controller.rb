class SearchController < ApplicationController

  def index
    #find all of the countries for users to select from
    @countries  = Country.find(:all)
    session[:countries] = nil
  end
  
  #this will take in specific data from the search page
  #find the associated data, and create a @graph object 
  #to be displayed
  def do_search
    #set session variables graph_code to use when building
    #data set for display
    @countries = []
    if params[:country].nil? or params[:equip].nil?
      flash[:notice] = "You must select a country and equipment level before you can continue."
      redirect_to :action => 'index' and return
    end
    params[:country].each do |c|
      @countries << c
    end
    session[:countries] = @countries
    session[:equip] = params[:equip]
    redirect_to :action => 'result'      
  end
  
  def result
    country_ids = session[:countries]
    equip = session[:equip]
    countries = []
    country_ids.each do |id|
      countries << Country.find(id)
    end
    @graph = {}
    #todo get all usage levels into same denomination
    countries.each do |country|
      country.providers.each do |port|
        port.plans.each do |plan|
          @graph["#{port.name} : #{plan.name} (#{plan.plan_type})"] = generate_data(plan, equip)
        end
      end
    end
  end
  
  def advanced
    @countries  = Country.find(:all)
  end
  
  def advanced_result
  	#generate bar graph of plans in country or 3 lowest plans
    @usage = params[:usage]
    @usage_unit = params[:usage_unit]
    #convert usage to MB
    usage_mb = convert_to_mb( @usage.to_f, @usage_unit )
    
    country_id = params[:country_id]
    country = Country.find(params[:country_id])
    @plans = {}
    @highcost = 0
    country.providers.each do |provider|
      provider.plans.each do |plan|
        cost = generate_cost(plan, usage_mb)
        @plans["#{provider.name} : #{plan.name} (#{plan.plan_type})"] = cost
        @highcost = cost if cost > @highcost
      end
    end
    @highcost *= 1.15
  end
  
  def analyst
  	
	end
  
  private
  	def generate_cost(plan, usage, equip)
  		#assumes usage is given in MB
  		equip_cost = 1
  		if equip == 'high'
  		  unless plan.provider.highcost.nil?
  		    equip_cost = plan.provider.highcost 
		    else
		      equip_cost = plan.highcost 
	      end
		  else
		    unless plan.provider.lowcost.nil?
		      equip_cost = plan.provider.lowcost
	      else
	        equip_cost = plan.lowcost
        end
	    end
	    equip_cost /= 60.0
      tax = plan.tax / 100.0 + 1.0
      #convert plan usage cap to mb and then compare to plan cap
      plan_usage_cap = 0
      unless plan.usage.nil?
        plan_usage_cap = convert_to_mb(plan.usage, plan.usage_unit)
      else
        plan_usage_cap = convert_to_mb(plan.day, plan.day_usage_unit)
        plan_usage_cap += convert_to_mb(plan.night, plan.night_usage_unit)
      end
    	#convert overage unit to MB to keep everything kosher
    	overage_increments = 1
    	unless plan.incremental_unit == 'MB'
  			overage_increments = convert_to_mb(1, plan.incremental_unit)
			end
    	
    	#test if actual usage is greater than plan limit and set cost
    	cost = 0
    	if usage < plan_usage_cap
    		cost = (plan.cost + equip_cost) * tax
  		else
  			cost = ((plan.cost + equip_cost) + (((usage - plan_usage_cap) / overage_increments.to_f) * plan.overage)) * tax
  		end
  		cost
  	end
  	
  	def convert_to_mb(usage, unit)
  		converted = usage
  		if unit == 'GB'
  			converted = usage * 1024.00
  		elsif unit == 'KB'
  			converted = usage / 1024.00
			end
  		converted
  	end
  	
	  def generate_data(plan, equip)
	  	values = []
	  	plan_usage_cap = convert_to_mb( plan.usage, plan.usage_unit )
	    #generate 4 usage levels below usage cap (0%, %25, 50%, 75%)
	    [0,1,2,4].each do |x|
	    	usage = plan_usage_cap / 4.0 * x
	    	cost = generate_cost(plan, usage, equip)
	    	values << [usage, cost]
	    end
	    #generate 3 usage levels above usage cap (125%, 150%, 175%)
	    [1,2,3].each do |x|
	    	usage = plan_usage_cap + ((plan_usage_cap / 4.0) * x)
	    	cost = generate_cost(plan, usage, equip)
	    	values << [usage, cost]
    	end
    	values
	  end
	  
	  #takes a currency code and returns the conversion rate to USD (for comparing countries)
	  def convert_to_usd(currency)
	    url = 'http://www.webservicex.net/CurrencyConvertor.asmx/ConversionRate?ToCurrency=USD&FromCurrency=' + currency.upcase
	    xml = Net::HTTP.get_response(URI.parse(url)).body
	    rate_regex = /\>\d+\.\d+\</
	    match = rate_regex.match(xml)
	    rate = 1
	    if match
	      rate = match[0].gsub(/\<|\>/, '').to_f
	    end
	    rate
	  end
end