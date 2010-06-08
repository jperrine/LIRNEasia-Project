class Plan < ActiveRecord::Base
  validates_presence_of :name, :cost, :usage, :overage, :speed_unit, :speed, :tax, :description,
   :plan_type, :speed_unit, :day_usage_unit, :night_usage_unit, :incremental_unit
  validates_inclusion_of :speed_unit, :day_usage_unit, :night_usage_unit, :incremental_unit, 
      :in => %w( MB GB KB ), :message => "Unit {{value}} is an acceptable rate, use GB, MB or KB."
  validates_inclusion_of :plan_type, :in => %w( Prepaid Postpaid ), :message => "Plan types can be either Postpaid or Prepaid."
  
  belongs_to :provider
end