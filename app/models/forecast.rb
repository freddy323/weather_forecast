# frozen_string_literal: true

class Forecast # rubocop:disable Style/Documentation
  attr_reader :current_forecast, :daily_forecasts, :location_name,
              :cache_timestamp, :time_zone, :coordinates

  def initialize(address)
    @address = address.to_s.strip
    raise ArgumentError, 'Address cannot be blank' if @address.empty?
  end

  def fetch
    @coordinates = AddressGeocoder.new(@address).coordinates
    weather_data = WeatherService.new(@coordinates).fetch
    parse_weather_data(weather_data)
    self
  rescue StandardError => e
    Rails.logger.error "Forecast error: #{e.message}\n#{e.backtrace.join("\n")}"
    raise "Failed to retrieve forecast: #{e.message}"
  end

  def current_temperature
    current_forecast['temperature']
  end

  def temperature_unit
    current_forecast['temperatureUnit']
  end

  def high_temperature
    daily_forecasts.first['temperature']
  end

  def low_temperature
    daily_forecasts.last['temperature']
  end

  def cached?
    !!@cache_timestamp
  end

  private

  def parse_weather_data(data)
    periods = data.dig('properties', 'periods') || []
    raise 'No forecast data available' if periods.empty?

    @current_forecast = find_current_period(periods)
    @daily_forecasts = find_daily_periods(periods)
    @location_name = @current_forecast['name']
    @time_zone = data.dig('properties', 'timeZone') || 'America/New_York'
    @cache_timestamp = Time.current
  end

  def find_current_period(periods)
    # Find the current daytime period or first available
    periods.find { |p| p['isDaytime'] && Time.parse(p['startTime']) <= Time.current } || periods.first
  end

  def find_daily_periods(periods)
    # Group by date and find daytime high/nighttime low for each day
    periods.group_by { |p| Date.parse(p['startTime']) }
           .values
           .map { |day_periods| analyze_day_periods(day_periods) }
           .first(3) # Return next 3 days
  end

  def analyze_day_periods(periods) # rubocop:disable Metrics/MethodLength
    daytime = periods.find { |p| p['isDaytime'] }
    nighttime = periods.find { |p| !p['isDaytime'] }

    {
      'daytime' => daytime,
      'nighttime' => nighttime,
      'temperature' => daytime['temperature'],
      'low' => nighttime['temperature'],
      'shortForecast' => daytime['shortForecast'],
      'detailedForecast' => daytime['detailedForecast'],
      'icon' => daytime['icon']
    }
  end
end
