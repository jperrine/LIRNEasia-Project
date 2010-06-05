class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.string        :name
      t.float         :cost
      t.float         :usage
      t.float         :day
      t.float         :night
      t.float         :precost
      t.float         :preusage
      t.string        :description
      t.float         :overage
      t.string        :speed_unit
      t.float         :highcost
      t.string        :highproduct
      t.float         :lowcost
      t.string        :lowproduct
      t.float         :speed
      t.float         :tax
      t.integer       :provider_id
      t.timestamps
    end
  end

  def self.down
    drop_table :plans
  end
end
