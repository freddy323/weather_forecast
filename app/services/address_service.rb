# Service to handle address processing and geocoding
class AddressService
  class InvalidAddressError < StandardError; end

  def initialize(address)
    @address = address.to_s.strip
  end

  def coordinates
    validate_address
    # In a real app, we'd use a geocoding service like Google Maps or Mapbox
    # This is a simplified version that just extracts zip code
    { zip_code: extract_zip_code }
  end

  private

  def validate_address
    raise InvalidAddressError, "Address cannot be blank" if @address.empty?
  end

  def extract_zip_code
    # Simple US zip code extraction - would need enhancement for production
    match = @address.match(/\b\d{5}(?:-\d{4})?\b/)
    match ? match[0] : (raise InvalidAddressError, "No valid zip code found")
  end
end
