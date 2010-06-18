class AddAmountToUsageLevels < ActiveRecord::Migration
  def self.up
    add_column :usage_levels, :amount, :decimal
  end

  def self.down
    remove_column :usage_levels, :amount
  end
end
