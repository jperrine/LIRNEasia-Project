class MoveInstallationCostToPlanLevel < ActiveRecord::Migration
  def self.up
    remove_column :providers, :installation
    add_column :plans, :installation, :float
  end

  def self.down
    add_column :providers, :installation, :float
    remove_column :plans, :installation
  end
end
