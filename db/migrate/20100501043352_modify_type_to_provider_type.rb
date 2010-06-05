class ModifyTypeToProviderType < ActiveRecord::Migration
  def self.up
    rename_column :providers, :type, :provider_type
  end

  def self.down
    rename_column :providers, :provider_type, :type
  end
end
