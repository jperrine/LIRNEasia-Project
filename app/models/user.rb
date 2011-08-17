class User < ActiveRecord::Base
  validates_presence_of :username, :password, :country_id
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 6
  validates_uniqueness_of :username
  
  belongs_to :country
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

