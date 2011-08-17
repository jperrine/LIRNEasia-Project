require 'test_helper'

class PlanTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: plans
#
#  id               :integer         primary key
#  name             :string(255)
#  cost             :float
#  usage            :float
#  day              :float
#  night            :float
#  description      :string(255)
#  overage          :float
#  speed_unit       :string(255)
#  highcost         :float
#  highproduct      :string(255)
#  lowcost          :float
#  lowproduct       :string(255)
#  speed            :float
#  tax              :float
#  provider_id      :integer
#  created_at       :timestamp
#  updated_at       :timestamp
#  usage_unit       :string(255)
#  day_usage_unit   :string(255)
#  night_usage_unit :string(255)
#  incremental_unit :string(255)
#  plan_type        :string(255)
#  installation     :float
#

