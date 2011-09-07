class SearchController < ApplicationController
  before_filter :get_provider_type, :only => [:result, :bandwidth_results, :advanced_result, :countries_results]
  
  def help  
  end
  
  def index
  end
  
  def default
    #find all of the countries for users to select from
    @countries  = Country.find(:all)
  end
  
  def result
    if params[:cid].nil? or params[:equip].nil? or params[:provider].nil?
      redirect_to :action => :default and return
    end
    @country = Country.find(params[:cid])
    equip = params[:equip]
    @graph = {}
    highest = nil
    
    comparator = lambda { |p| p.provider_type == @provider_type }
    
    @last_update = @country.providers.select(&comparator).collect(&:plans).flatten.collect(&:updated_at).sort.last
    
    @country.providers.select(&comparator).each do |port|
      port.plans.each do |plan|
        @graph["#{port.name} : #{plan.name} (#{plan.plan_type})"] = generate_data(plan, equip)
        if highest.nil? || @graph["#{port.name} : #{plan.name} (#{plan.plan_type})"][-1][0] > highest
          highest = @graph["#{port.name} : #{plan.name} (#{plan.plan_type})"][-1][0]
        end
      end
    end
    @country.providers.select(&comparator).each do |port|
      port.plans.each do |plan|
        unless highest == @graph["#{port.name} : #{plan.name} (#{plan.plan_type})"][-1][0]
          @graph["#{port.name} : #{plan.name} (#{plan.plan_type})"] += [[highest, generate_cost(plan, highest, equip)]]
        end
      end
    end
  end
  
  def bandwidth
    @usage_levels = UsageLevel.all
    @countries = Country.all
    @bandwidths = []
    @countries.each do |country|
      country.providers.each do |provider|
        provider.plans.each do |plan|
          @bandwidths << "#{plan.speed} #{plan.speed_unit}"
        end
      end
    end
    @bandwidths.uniq!
  end
  
  def bandwidth_results
    if params[:countries].nil? or params[:equip].nil? or params[:provider].nil?
      redirect_to :action => :bandwidth and return
    end
    equip = params[:equip]
    
    
    @countries = Country.all(:conditions => ["ID in (?)", params[:countries]])
    
    speed = params[:bandwidth].split.first.to_f
    speed_unit = params[:bandwidth].split.last
    
    @usage = 0
    @usage_unit = ''
    unless params[:usage]
      @usage = params[:usage]
      @usage_unit = params[:usage_unit]      
    else
      level = UsageLevel.find(params[:usage_level])
      @usage = level.amount
      @usage_unit = level.unit
    end
    #convert usage to MB
    usage_mb = convert_to_mb( @usage.to_f, @usage_unit )
    
    @graph = {}
    @last_update, @lowcost, @lowplan, lowplankey = nil
    @lowest_usd = 0
    
    @countries.each do |country|
      country.providers.select{|p| p.provider_type == @provider_type}.each do |provider|
        provider.plans.select{|p| p.speed == speed and p.speed_unit == speed_unit }.each do |plan|
          @last_update = @last_update.nil? ? plan.updated_at : @last_update < plan.updated_at ? plan.updated_at : @last_update
          cost = generate_cost(plan, usage_mb, equip)
          cost_usd = ((cost * country.to_usd_rate) * 100).round.to_f / 100 
          @graph["#{country.country}: #{provider.name} - #{plan.name}"] = cost_usd
          if @lowcost.nil? or cost_usd < @lowcost
            @lowcost, @lowplan = cost, plan
            @lowest_usd = cost_usd
            lowplankey = "#{country.country}: #{provider.name} - #{plan.name}"
          end
        end
      end
    end
    @lowest = @graph.select {|x,y| y == @lowcost and x != lowplankey }
    @lowcost = @lowcost.nil? ? nil : (@lowcost * 100).round.to_f / 100
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
    @lowcost, @lowplan, lowplankey = nil
    comparator = lambda {|p| p.provider_type == @provider_type}
    country.providers.select(&comparator).each do |provider|
      provider.plans.each do |plan|
        cost = generate_cost(plan, usage_mb, params[:equip])
        @plans["#{provider.name} : #{plan.name} (#{plan.plan_type})"] = cost
        if @lowcost.nil? or cost < @lowcost
          @lowcost, @lowplan = cost, plan
          lowplankey = "#{provider.name} : #{plan.name} (#{plan.plan_type})"
        end
      end
    end
    
    @last_update = country.providers.select(&comparator).collect(&:plans).flatten.collect(&:updated_at).sort.last
    
    @lowest = @plans.select {|x,y| y == @lowcost and x != lowplankey }
    @lowcost = (@lowcost * 100).round.to_f / 100
  end
  
  def countries
    #compares plans for usage level across countries, also able to choose prepay/postpay mobile/fixed
    @usage_levels = UsageLevel.all
    @countries = Country.all
  end
  
  def countries_results
    if params[:usage].nil? or params[:usage_level].nil? or params[:countries].nil? or params[:equip].nil?
      redirect_to :action => :countries and return
    end
    @usage = 0
    @usage_unit = ''
    unless params[:usage]
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
    @plan_type = params[:plan]
    
    @plans = {}
    @last_update, @lowcost, @lowplan, lowplankey, @lowest_usd = nil

    params[:countries].each do |id|
      country = Country.find(id)
      country.providers.select {|p| p.provider_type == @provider_type }.each do |provider|
        provider.plans.select{|p| p.plan_type == @plan_type }.each do |plan|
          @last_update = @last_update.nil? ? plan.updated_at : @last_update < plan.updated_at ? plan.updated_at : @last_update
          cost = generate_cost(plan, usage_mb, equip)
          cost_usd = ((cost * country.to_usd_rate) * 100).round.to_f / 100
          key = "#{country.country}: #{provider.name} - #{plan.name}"
          @plans[key] = cost_usd
          if @lowcost.nil? or cost_usd < @lowest_usd
            @lowcost, @lowplan = cost, plan
            @lowest_usd = cost_usd
            lowplankey = key
          end
        end
      end
    end
    @lowest = @plans.select {|x,y| y == @lowest_usd and x != lowplankey }
    @lowcost = (@lowcost * 100).round.to_f / 100
    @lowest_usd = (@lowest_usd * 100).round.to_f / 100
  end
  
  private
  	def generate_cost(plan, usage, equip)
  		#assumes usage is given in MB
  		equip_cost = 0
  		if equip == 'high'
  		  unless plan.provider.highcost == 0.00 or plan.provider.highcost == nil
  		    equip_cost = plan.provider.highcost 
		    else
		      equip_cost = plan.highcost == nil ? 0.00 : plan.highcost
	      end
	      equip_cost /= 60.0
		  elsif equip == 'low'
		    unless plan.provider.lowcost == 0.00 or plan.provider.lowcost == nil
		      equip_cost = plan.provider.lowcost
	      else
	        equip_cost = plan.lowcost == nil ? 0.00 : plan.lowcost
        end
        equip_cost /= 60.0
	    end
	    
	    if plan.provider.provider_type == "Fixed"
	      equip_cost = plan.installation == nil ? 0.00 : plan.installation
      end
      
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
      (cost * 100).round.to_f / 100
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
      #new range 0%, 25%, 50%, 75%, 100%, 125%
      (0..4).each do |x|
        values << [x/4.0 * plan_usage_cap, generate_cost(plan, x/4.0 * plan_usage_cap, equip)]
      end
	  	values << [plan_usage_cap * 1.25, generate_cost(plan, plan_usage_cap * 1.25, equip)]
    	values
	  end
	  
	  def get_provider_type
      @provider_type = %w(Mobile Fixed).include?(params[:provider]) ? params[:provider] : "Mobile"
    end
end