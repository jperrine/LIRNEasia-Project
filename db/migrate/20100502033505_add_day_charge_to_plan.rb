class AddDayChargeToPlan < ActiveRecord::Migration
  def self.up
    add_column :plans, :dayoverage, :float
  end

  def self.down
    remove_column :plans, :dayoverage
  end
end
