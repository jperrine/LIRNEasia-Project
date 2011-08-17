class UsageLevel < ActiveRecord::Base
  validates_presence_of :name, :amount, :unit
  validates_inclusion_of :unit, :in => %w( KB MB GB ), :message => "Unit {{value}} is an acceptable rate, use GB, MB or KB."
end

# == Schema Information
#
# Table name: usage_levels
#
#  id         :integer         primary key
#  name       :string(255)
#  unit       :string(255)
#  created_at :timestamp
#  updated_at :timestamp
#  amount     :decimal(, )
#

