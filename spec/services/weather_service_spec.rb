require 'rails_helper'

RSpec.describe WeatherService do
  describe ".fetch_forecast" do
    let(:zip_code) { "10001" }
    subject { described_class.fetch_forecast(zip_code) }

    it "returns forecast data with current conditions" do
      expect(subject[:current]).to include(
        :temp_f,
        :temp_c,
        :condition,
        :humidity,
        :wind_mph
      )
    end

    it "returns forecast data with daily forecast" do
      expect(subject[:forecast][:forecastday].first[:day]).to include(
        :maxtemp_f,
        :mintemp_f
      )
    end
  end
end
