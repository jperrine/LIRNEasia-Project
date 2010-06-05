class BreakPlansIntoPreOrPostPay < ActiveRecord::Migration
  def self.up
    remove_column :plans, :precost
    remove_column :plans, :preusage
    remove_column :plans, :prepayday
    remove_column :plans, :prepaynight
    remove_column :plans, :prepay_usage_unit
    remove_column :plans, :prepay_night_usage_unit
    remove_column :plans, :prepay_day_usage_unit
    
    add_column :plans, :plan_type, :string
  end

  def self.down
    add_column :plans, :precost, :float
    add_column :plans, :preusage, :float
    add_column :plans, :prepayday, :float
    add_column :plans, :prepaynight, :float
    add_column :plans, :prepay_usage_unit, :string
    add_column :plans, :prepay_night_usage_unit, :string
    add_column :plans, :prepay_day_usage_unit, :string
    
    remove_column :plans, :plan_type
  end
end
