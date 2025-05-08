# frozen_string_literal: true

class AddressGeocoder
  include HTTParty
  base_uri 'https://nominatim.openstreetmap.org'
  default_timeout 5

  # Add a small delay between requests to comply with Nominatim's usage policy
  REQUEST_DELAY = 1.1 # seconds

  def initialize(address)
    @address = address.to_s.strip
    raise ArgumentError, 'Address cannot be blank' if @address.empty?
  end

  def coordinates
    sleep REQUEST_DELAY # Respect rate limits
    response = self.class.get('/search', query_options)

    validate_response(response)
    extract_coordinates(response)
  rescue StandardError => e
    Rails.logger.error "Geocoding error: #{e.message}"
    raise "We couldn't locate that address. Please try again with a more specific location."
  end

  private

  def query_options
    {
      query: {
        q: @address,
        format: 'json',
        addressdetails: 1,
        limit: 1,
        countrycodes: 'us' # Optional: restrict to US for better US address results
      },
      headers: {
        'User-Agent' => 'WeatherApp/1.0 (contact@example.com)',
        'Accept' => 'application/json',
        'Referer' => 'http://localhost:3000' # Required by Nominatim
      }
    }
  end

  def validate_response(response)
    raise "Geocoding service responded with #{response.code}: #{response.message}" unless response.success?

    return unless response.parsed_response.empty?

    raise "No results found for address: #{@address}"
  end

  def extract_coordinates(response)
    result = response.parsed_response.first
    lat = result['lat']&.to_f
    lon = result['lon']&.to_f

    raise 'Invalid coordinates received from geocoding service' if lat.nil? || lon.nil?

    [lat, lon]
  end
end
