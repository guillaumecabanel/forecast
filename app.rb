require_relative 'forecast_cli'

def display_forecast
  if Forecast::CITIES.map(&:downcase).include? ARGV[0].downcase
    begin
      puts ""
      puts ForecastCLI.now(ARGV[0])
      puts ""
      puts ForecastCLI.today(ARGV[0])
      puts "------------------------------------------"
      puts ""
      puts ForecastCLI.tomorrow(ARGV[0])
    rescue SocketError => e
      puts "Error: "
      puts e
    end
  else
    puts "Unavailable city, type `forecast cities` to get the available cities"
  end
end

def display_cities
  puts "Available cities:"
  Forecast::CITIES.each_with_index do |city, index|
    break if index >= Forecast::CITIES.count / 2
    print "- #{city}"
    puts  "#{' ' * (20 - city.length)} - #{Forecast::CITIES[index + (Forecast::CITIES.count / 2)]}"
  end
  puts ""
end

def display_help
  puts "Forecast help:"
  puts ""
  puts "forecast CITY       # display forecast"
  puts "forecast cities     # display available cities"
end

if ARGV.any?
  return display_cities if ARGV[0] === 'cities'
  display_forecast
else
  display_help
end
