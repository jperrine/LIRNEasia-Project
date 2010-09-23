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
