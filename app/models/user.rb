class User < ActiveRecord::Base
  validates_presence_of :username, :password
  validates_confirmation_of :password
  validates_length_of :password, :minimum => 6
  validates_uniqueness_of :username
  
end
