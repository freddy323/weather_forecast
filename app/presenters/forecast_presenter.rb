class ForecastPresenter
  def initialize(forecast_data, cached: false)
    @forecast = forecast_data.deep_symbolize_keys
    @cached = cached
  end

  def current_temp
    "#{@forecast.dig(:current, :temp_f).round(1)}°F"
  end

  def conditions
    @forecast.dig(:current, :condition, :text)
  end

  def high_temp
    "#{@forecast.dig(:forecast, :forecastday, 0, :day, :maxtemp_f).round(1)}°F"
  end

  def low_temp
    "#{@forecast.dig(:forecast, :forecastday, 0, :day, :mintemp_f).round(1)}°F"
  end

  def cached?
    @cached
  end
end
