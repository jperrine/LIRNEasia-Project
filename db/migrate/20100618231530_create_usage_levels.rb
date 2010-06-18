class CreateUsageLevels < ActiveRecord::Migration
  def self.up
    create_table :usage_levels do |t|
      t.string  :name
      t.int     :amount
      t.string  :unit
      t.timestamps
    end
  end

  def self.down
    drop_table :usage_levels
  end
end
