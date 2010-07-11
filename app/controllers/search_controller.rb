class SearchController < ApplicationController

  def help  
  end
  
  def index
    #find all of the countries for users to select from
    @countries  = Country.find(:all)
  end
  
  def result
    if params[:cid].nil? or params[:equip].nil?
      redirect_to :action => 'index' and return
    end
    @country = Country.find(params[:cid])
    equip = params[:equip]
    
    @graph = {}
    highest = nil
    @country.providers.each do |port|
      port.plans.each do |plan|
        @graph["#{port.name} : #{plan.name} (#{plan.plan_type})"] = generate_data(plan, equip)
        if highest.nil? or @graph["#{port.name} : #{plan.name} (#{plan.plan_type})"][-1][0]
          highest = @graph["#{port.name} : #{plan.name} (#{plan.plan_type})"][-1][0]
        end
      end
    end
    @country.providers.each do |port|
      port.plans.each do |plan|
        @graph["#{port.name} : #{plan.name} (#{plan.plan_type})"] += [highest, generate_cost(plan, highest, equip)]
      end
    end
  end
  
  def advanced
    @countries = Country.all
    @usage_levels = UsageLevel.all
  end
  
  def advanced_result
  	#generate bar graph of plans in country or 3 lowest plans
  	if params[:usage].nil? or params[:usage_level].nil?
  	  redirect_to :action => :advanced and return
	  end
    @usage = 0
    @usage_unit = ''
    unless params[:usage].empty?
      @usage = params[:usage]
      @usage_unit = params[:usage_unit]      
    else
      level = UsageLevel.find(params[:usage_level])
      @usage = level.amount
      @usage_unit = level.unit
    end
    #convert usage to MB
    usage_mb = convert_to_mb( @usage.to_f, @usage_unit )
    
    country_id = params[:country_id]
    country = Country.find(params[:country_id])
    @plans = {}
    @lowcost, @lowplan = nil
    country.providers.each do |provider|
      provider.plans.each do |plan|
        cost = generate_cost(plan, usage_mb, params[:equip])
        @plans["#{provider.name} : #{plan.name} (#{plan.plan_type})"] = cost
        if @lowcost.nil? or cost < @lowcost
          @lowcost, @lowplan = cost, plan
        end
      end
    end
    @lowcost = (@lowcost * 100).round.to_f / 100
    
  end
  
  def countries
    #compares plans for usage level across countries, also able to choose prepay/postpay mobile/fixed
    @usage_levels = UsageLevel.all
    @countries = Country.all
  end
  
  def countries_results
    if params[:usage].nil? or params[:usage_level].nil? or params[:countries].nil? or params[:equip].nil? or params[:countries].empty?
      redirect_to :action => :countries and return
    end
    @usage = 0
    @usage_unit = ''
    unless params[:usage].empty?
      @usage = params[:usage]
      @usage_unit = params[:usage_unit]      
    else
      level = UsageLevel.find(params[:usage_level])
      @usage = level.amount
      @usage_unit = level.unit
    end
    #convert usage to MB
    usage_mb = convert_to_mb( @usage.to_f, @usage_unit )
    
    equip = params[:equip]
    @provider_type = params[:provider]
    @plan_type = params[:plan]
    
    @plans = {}
    @lowcost, @lowplan = nil
    @lowest_usd = 0
    params[:countries].each do |id|
      country = Country.find(id)
      country.providers.select {|p| p.provider_type == @provider_type }.each do |provider|
        provider.plans.select {|p| p.plan_type == @plan_type }.each do |plan|
          cost = generate_cost(plan, usage_mb, equip)
          cost_usd = convert_to_usd(cost, plan.provider.country.currency)
          @plans["#{country.country}: #{provider.name} - #{plan.name}"] = cost_usd
          if @lowcost.nil? or cost_usd < @lowcost
            @lowcost, @lowplan = cost, plan
            @lowest_usd = cost_usd
          end
        end
      end
    end
    @lowcost = (@lowcost * 100).round.to_f / 100
    @lowest_usd = (@lowest_usd * 100).round.to_f / 100
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
	    
	    if plan.provider.provider_type == "Fixed"
	      equip_cost = plan.provider.installation || 0
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
    	if usage <= plan_usage_cap
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
	  	usage = plan.usage != 0.0 ? plan.usage : (plan.day + plan.night)
	  	plan_usage_cap = convert_to_mb( plan.usage, plan.usage_unit )
	    #generate 4 usage levels below usage cap (50%, 75%, 100%)
	    [1,2,4].each do |x|
	    	usage = plan_usage_cap / 4.0 * x
	    	cost = generate_cost(plan, usage, equip)
	    	values << [usage, cost]
	    end
	    #generate 3 usage levels above usage cap (125%, 150%)
	    [1,2].each do |x|
	    	usage = plan_usage_cap + ((plan_usage_cap / 4.0) * x)
	    	cost = generate_cost(plan, usage, equip)
	    	values << [usage, cost]
    	end
    	values
	  end
	  
	  #takes a currency code and returns the conversion rate to USD (for comparing countries)
	  def convert_to_usd(amount, currency)
	    url = 'http://www.webservicex.net/CurrencyConvertor.asmx/ConversionRate?ToCurrency=USD&FromCurrency=' + currency.upcase
	    xml = Net::HTTP.get_response(URI.parse(url)).body
	    rate_regex = /\>\d+\.\d+\</
	    match = rate_regex.match(xml)
	    rate = 1
	    if match
	      rate = match[0].gsub(/\<|\>/, '').to_f
	    end
	    amount * rate
	  end
end