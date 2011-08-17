require 'test_helper'

class CountryTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end

# == Schema Information
#
# Table name: countries
#
#  id          :integer         primary key
#  currency    :string(255)
#  country     :string(255)
#  created_at  :timestamp
#  updated_at  :timestamp
#  to_usd_rate :float
#

