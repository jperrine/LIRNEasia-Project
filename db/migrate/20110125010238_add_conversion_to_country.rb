class AddConversionToCountry < ActiveRecord::Migration
  def self.up
    add_column :countries, :to_usd_rate, :float
  end

  def self.down
    remove_column :countries, :to_usd_rate
  end
end
