# Service to interact with weather API
class WeatherService
  API_KEY = Rails.application.credentials.weather_api_key
  BASE_URL = "https://api.weatherapi.com/v1".freeze

  def self.fetch_forecast(zip_code)
    new(zip_code).fetch_forecast
  end

  def initialize(zip_code)
    @zip_code = zip_code
  end

  def fetch_forecast
    # In a real app, we'd make an actual API call
    # This is a mock implementation with sample data
    {
      current: {
        temp_f: 72.5,
        temp_c: 22.5,
        condition: "Sunny",
        humidity: 45,
        wind_mph: 3.2
      },
      forecast: {
        forecastday: [
          {
            day: {
              maxtemp_f: 78.3,
              mintemp_f: 65.2,
              avgtemp_f: 72.5,
              maxwind_mph: 5.8,
              totalprecip_in: 0.0,
              avgvis_miles: 10,
              avghumidity: 45,
              condition: {
                text: "Sunny",
                icon: "//cdn.weatherapi.com/weather/64x64/day/113.png"
              }
            }
          }
        ]
      }
    }
  end

  private

  def api_request(endpoint, params = {})
    params[:key] = API_KEY
    uri = URI("#{BASE_URL}/#{endpoint}")
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get_response(uri)
    JSON.parse(response.body, symbolize_names: true)
  rescue => e
    Rails.logger.error "Weather API Error: #{e.message}"
    raise WeatherAPIError, "Unable to fetch weather data"
  end
end
