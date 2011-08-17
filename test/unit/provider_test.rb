require 'test_helper'

class ProviderTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: providers
#
#  id            :integer         primary key
#  name          :string(255)
#  provider_type :string(255)
#  country_id    :integer
#  created_at    :timestamp
#  updated_at    :timestamp
#  highcost      :float
#  highproduct   :string(255)
#  lowcost       :float
#  lowproduct    :string(255)
#

