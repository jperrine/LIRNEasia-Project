class Country < ActiveRecord::Base
  validates_presence_of :currency, :country
  has_many :providers
end
