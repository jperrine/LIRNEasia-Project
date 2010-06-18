class UsageLevel < ActiveRecord::Base
  validates_presence_of :name, :amount, :unit
  validates_inclusion_of :unit, :in => %w( KB MB GB ), :message => "Unit {{value}} is an acceptable rate, use GB, MB or KB."
end
