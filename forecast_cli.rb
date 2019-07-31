require 'paint'
require_relative 'forecast'

class ForecastCLI < Forecast
  class << self
    def now(city)
      "Actuellement à #{city.capitalize}           #{ForecastCLI.colorised_temperature forecasts_data(city)['TempInst'].to_i}°C"
    end

    def colorised_temperature(temperature)
      if temperature < 5
        color = "#3498db"
      elsif temperature < 10
        color = "#2980b9"
      elsif temperature < 15
        color = "#1abc9c"
      elsif temperature < 20
        color = "#16a085"
      elsif temperature < 25
        color = "#27ae60"
      elsif temperature < 30
        color = "#e67e22"
      else
        color = "#d35400"
      end

      Paint["🌡 #{temperature}", color]
    end
  end

  def to_s
    <<-TXT
 Prévisions pour #{humanized_date(date)} à #{city}

    Matin    | Après-midi |     Soir
             |            |
  #{PICTOS[morning_pic]}  #{ForecastCLI.colorised_temperature morning_min_temp}°C |  #{PICTOS[afternoon_pic]}  #{ForecastCLI.colorised_temperature afternoon_max_temp}°C |  #{PICTOS[evening_pic]}  #{ForecastCLI.colorised_temperature evening_min_temp}°C

 #{description}
    TXT
  end

  private

  def humanized_date(date)
    if date == Date.today
      human_date = "aujourd'hui"
    elsif date == Date.today + 1
      human_date = "demain"
    else
      human_date = "le #{date.strftime('%d.%m.%Y')}"
    end

    Paint[human_date, '#e74c3c']
  end
end
