class RemoveDailyIncCharge < ActiveRecord::Migration
  def self.up
    #move daily incremental charge to incremental charge
    Plan.all.each do |plan|
      if (plan.dayoverage || 0.0) > 0.0
        plan.overage = plan.dayoverage
      end
    end
    remove_column :plans, :dayoverage
  end

  def self.down
    add_column :plans, :dayoverage, :float, :default => 0.0
  end
end
