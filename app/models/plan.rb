class Plan < ActiveRecord::Base
  validates_presence_of :name, :cost, :usage, :overage, :speed_unit, :speed, :tax, :description,
   :plan_type, :speed_unit, :day_usage_unit, :night_usage_unit, :incremental_unit
  validates_inclusion_of :speed_unit, :day_usage_unit, :night_usage_unit, :incremental_unit, 
      :in => %w( MB GB KB ), :message => "Unit {{value}} is an acceptable rate, use GB, MB or KB."
  validates_inclusion_of :plan_type, :in => %w( Prepaid Postpaid ), :message => "Plan types can be either Postpaid or Prepaid."
  validate :no_nulls
  
  belongs_to :provider
  
  def no_nulls
    self.installation ||= 0.00
    self.day ||= 0.00
    self.night ||= 0.00
    self.highcost ||= 0.00
    self.lowcost ||= 0.00
  end
end
# == Schema Information
#
# Table name: plans
#
#  id               :integer         primary key
#  name             :string(255)
#  cost             :float
#  usage            :float
#  day              :float
#  night            :float
#  description      :string(255)
#  overage          :float
#  speed_unit       :string(255)
#  highcost         :float
#  highproduct      :string(255)
#  lowcost          :float
#  lowproduct       :string(255)
#  speed            :float
#  tax              :float
#  provider_id      :integer
#  created_at       :timestamp
#  updated_at       :timestamp
#  usage_unit       :string(255)
#  day_usage_unit   :string(255)
#  night_usage_unit :string(255)
#  incremental_unit :string(255)
#  plan_type        :string(255)
#  installation     :float
#

