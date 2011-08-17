require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
end


# == Schema Information
#
# Table name: users
#
#  id         :integer         primary key
#  username   :string(255)
#  password   :string(255)
#  created_at :timestamp
#  updated_at :timestamp
#  country_id :integer
#

