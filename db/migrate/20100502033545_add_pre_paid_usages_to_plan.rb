class AddPrePaidUsagesToPlan < ActiveRecord::Migration
  def self.up
    add_column :plans, :prepayday, :float
    add_column :plans, :prepaynight, :float
  end

  def self.down
    remove_column :plans, :prepayday
    remove_column :planns, :prepaynight
  end
end
