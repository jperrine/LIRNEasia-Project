class Country < ActiveRecord::Base
  validates_presence_of :currency, :country
  has_many :providers, :dependent => :destroy
  
  def update_conversion_rate
    url = "http://webservicex.net/CurrencyConvertor.asmx/ConversionRate?FromCurrency=#{currency.upcase}&ToCurrency=USD"
    xml = nil
    begin
      xml = Net::HTTP.get_response(URI.parse(url)).body
    rescue
    end
    rate_regex = /\>\d+\.\d+\</
    match = rate_regex.match(xml)
    rate = 1
    if match
      rate = match[0].gsub(/\<|\>/, '').to_f
    end
    self.to_usd_rate = rate || 1
  end
end
