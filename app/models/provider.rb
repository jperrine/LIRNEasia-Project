class Provider < ActiveRecord::Base
  validates_presence_of :name, :provider_type
  validates_inclusion_of :provider_type, :in => %w( Mobile Fixed ), :message => "{{value}} is not an acceptable type, use either mobile or fixed."
  
  belongs_to :country
  has_many :plans
end
