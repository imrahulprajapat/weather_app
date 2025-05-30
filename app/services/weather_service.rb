class WeatherService
  include HTTParty
  base_uri 'https://api.openweathermap.org/data/2.5'

  EXPIRY = 30.minutes
  attr_reader :lat, :lon, :cache_key, :api_key

  def initialize(lat, lon, cache_key)
    @lat = lat
    @lon = lon
    @cache_key = cache_key
    @api_key = ENV['OPENWEATHERMAP_API_KEY']
  end

  def call
    if (cached = Rails.cache.read(cache_key))
      [cached, true]  
    else
      raw_response = fetch_weather
      return [nil, nil] unless raw_response.success?

      parsed = parse_response(raw_response)
      write_to_cache(parsed)
      [parsed, false]
    end
  end

  private

  def fetch_weather
    self.class.get('/weather', query: {
      lat: lat,
      lon: lon,
      units: 'metric',
      appid: api_key
    })
  end

  def parse_response(response)
    {
      temperature: response['main']['temp'],
      high: response['main']['temp_max'],
      low: response['main']['temp_min'],
      description: response['weather'][0]['description'],
      name: response['name']
    }
  end

  def write_to_cache(response)
    Rails.cache.write(cache_key, response, expires_in: EXPIRY)
  end
end
