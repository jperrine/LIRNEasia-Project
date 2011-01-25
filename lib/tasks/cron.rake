desc "This task updates each countries conversion to USD rate for usage in comparison"

task :cron => :environment do
  Country.all.each do |country|
    country.update_conversion_rate
    country.save
  end
end