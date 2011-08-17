require 'digest/sha1'
User.destroy_all

User.create(:username => 'admin', :password => Digest::SHA1.hexdigest('@dm1nP@$$'))
Country.all.each do |country|
  name = country.country.downcase.gsub(/\s/, '_')
  User.create(:username => name, :country => country, :password => Digest::SHA1.hexdigest(name))
end