require 'httparty'

class Forecast
  attr_reader :city,
              :date,
              :description,
              :sunrise,
              :sunset,
              :morning_min_temp,
              :morning_max_temp,
              :morning_pic,
              :afternoon_min_temp,
              :afternoon_max_temp,
              :afternoon_pic,
              :evening_min_temp,
              :evening_max_temp,
              :evening_pic,
              :night_min_temp,
              :night_max_temp,
              :night_pic

  BASE_URL = "http://data.meteo-villes.com/previsions12j6.php?ville="

  CITIES = %w[Angers Annecy Biarritz Bordeaux Bruxelle Bruxelles Cannes Chambery Chamrouss Clermont-Ferrand Dijon Gap Geneve Grenoble Le\ Havre Lille Londres Lyon Marseille Metz Montpellier Nantes Nice Nîmes Paris Reims Rennes Rouen Saint-Étienne Strasbourg Toulon Toulouse]

   
  PICTOS = ['', '☀', '🌤', '⛅', '🌥', '🌦', '🌦', '🌨', '🌨', '🌨', '', '🌩', '⛈', '', '☁', '🌧', '🌧', '🌧', '🌨', '🌨', '🌨', '🌫', '⛈', '🌙', '🌤', '⛅', '🌦', '🌦', '🌨', '🌨', '🌨', '', '🌩', '⛈']

  class << self
    def forecasts_data(city)
      HTTParty.get("#{BASE_URL}#{city.downcase}")['previsions']
    end
    
    def today(city)
      new(city, forecasts_data(city)['prevision'][1])
    end

    def tomorrow(city)
      new(city, forecasts_data(city)['prevision'][2])
    end
  end

  def initialize(city, attributes = {})
    @city               = city.capitalize
    @date               = Date.parse(attributes['dateIso'])
    @sunrise            = attributes['leverSoleil']
    @sunset             = attributes['coucherSoleil']
    
    @morning_min_temp   = attributes['tempMinMatin'].to_i
    @morning_max_temp   = attributes['tempMaxMatin'].to_i
    @afternoon_min_temp = attributes['tempMinApresMidi'].to_i
    @afternoon_max_temp = attributes['tempMaxApresMidi'].to_i
    @evening_min_temp   = attributes['tempMinSoir'].to_i
    @evening_max_temp   = attributes['tempMaxSoir'].to_i
    @night_min_temp     = attributes['tempMinNuit'].to_i
    @night_max_temp     = attributes['tempMaxNuit'].to_i

    @morning_pic    = attributes["pictoMatin"].to_i
    @afternoon_pic  = attributes["pictoApresMidi"].to_i
    @evening_pic    = attributes["pictoSoiree"].to_i
    @night_pic      = attributes["pictoNuit"].to_i

    @description = parse_description(attributes['commentaire'])
  end

  private

  def parse_description(raw_description)
    raw_description.gsub(/(\s)?<\/?p>/, '')
  end
end
