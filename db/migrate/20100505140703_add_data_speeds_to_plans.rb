class AddDataSpeedsToPlans < ActiveRecord::Migration
  def self.up
    add_column :plans, :usage_unit, :string
    add_column :plans, :day_usage_unit, :string
    add_column :plans, :night_usage_unit, :string
    add_column :plans, :incremental_unit, :string
    add_column :plans, :prepay_usage_unit, :string
    add_column :plans, :prepay_night_usage_unit, :string
    add_column :plans, :prepay_day_usage_unit, :string
  end

  def self.down
    remove_column :plans, :usage_unit
    remove_column :plans, :day_usage_unit
    remove_column :plans, :night_usage_unit
    remove_column :plans, :incremental_unit
    remove_column :plans, :prepay_usage_unit
    remove_column :plans, :prepay_night_usage_unit
    remove_column :plans, :prepay_day_usage_unit
  end
end
