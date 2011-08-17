class Provider < ActiveRecord::Base
  validates_presence_of :name, :provider_type
  validates_inclusion_of :provider_type, :in => %w( Mobile Fixed ), :message => "{{value}} is not an acceptable type, use either mobile or fixed."
  validate :no_nulls
  
  belongs_to :country
  has_many :plans, :dependent => :destroy
  
  def no_nulls
    self.lowcost ||= 0.00
    self.highcost ||= 0.00
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

