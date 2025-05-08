# frozen_string_literal: true

class WeatherService
  include HTTParty
  base_uri 'https://api.weather.gov'
  format :json # Ensure responses are parsed as JSON

  def initialize(coordinates)
    @latitude, @longitude = coordinates
  end

  def fetch
    point_response = get_point_data
    forecast_url = point_response.dig('properties', 'forecast')
    raise 'No forecast URL found' unless forecast_url

    forecast_response = self.class.get(forecast_url)
    raise 'Failed to get forecast data' unless forecast_response.success?

    forecast_response.parsed_response
  rescue StandardError => e
    Rails.logger.error "WeatherService Error: #{e.message}"
    raise "Failed to retrieve weather data: #{e.message}"
  end

  private

  def get_point_data
    response = self.class.get("/points/#{@latitude},#{@longitude}")
    raise 'Failed to get weather point data' unless response.success?

    # Ensure the response is parsed as a Hash
    parsed = response.parsed_response
    parsed.is_a?(Hash) ? parsed : JSON.parse(parsed)
  rescue JSON::ParserError => e
    raise "Invalid JSON response from weather API: #{e.message}"
  end
end
