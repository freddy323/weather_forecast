class ForecastCacheService
  CACHE_DURATION = 30.minutes

  class << self
    def fetch(zip_code)
      new(zip_code).fetch
    end

    def cached?(zip_code)
      new(zip_code).cached?
    end
  end

  def initialize(zip_code)
    @zip_code = zip_code
  end

  def fetch
    cached = CacheForecast.find_by(zip_code: @zip_code)
    return cached.data if cached && cached.expires_at > Time.current

    forecast_data = WeatherService.fetch_forecast(@zip_code)
    cache_forecast(forecast_data)
    forecast_data
  end

  def cached?
    CacheForecast.exists?(zip_code: @zip_code, expires_at: Time.current..)
  end

  private

  def cache_forecast(data)
    CacheForecast.where(zip_code: @zip_code).destroy_all
    CacheForecast.create!(
      zip_code: @zip_code,
      data: data,
      expires_at: CACHE_DURATION.from_now
    )
  end
end
