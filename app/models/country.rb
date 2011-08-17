class Country < ActiveRecord::Base
  validates_presence_of :currency, :country
  validates_length_of :currency, :in => 3..3, :message => "Must enter a valid 3 digit currency code"
  has_many :providers, :dependent => :destroy
  has_many :users
  
  def update_conversion_rate
    url = "http://webservicex.net/CurrencyConvertor.asmx/ConversionRate?FromCurrency=#{currency.upcase}&ToCurrency=USD"
    xml = nil
    begin
      xml = Net::HTTP.get_response(URI.parse(url)).body
    rescue
    end
    rate_regex = /\>\d+\.\d+\</
    match = rate_regex.match(xml)
    if match
      self.to_usd_rate = match[0].gsub(/\<|\>/, '').to_f
    end
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

