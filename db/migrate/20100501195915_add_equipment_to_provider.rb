class AddEquipmentToProvider < ActiveRecord::Migration
  def self.up
    add_column :providers, :highcost, :float
    add_column :providers, :highproduct, :string
    add_column :providers, :lowcost, :float
    add_column :providers, :lowproduct, :string
  end

  def self.down
    remove_column :providers, :highcost
    remove_column :providers, :lowcost
    remove_column :providers, :highproduct
    remove_column :providers, :lowproduct
  end
end
