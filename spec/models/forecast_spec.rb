# spec/models/forecast_spec.rb
require 'rails_helper'

RSpec.describe Forecast, :vcr do
  let(:address) { 'New York, NY' }
  let(:forecast) { described_class.new(address) }

  describe '#fetch' do
    before { forecast.fetch }

    it 'returns temperature data' do
      expect(forecast.temperature).to be_a(Numeric)
    end

    it 'returns high temperature' do
      expect(forecast.high).to be_a(Numeric)
    end

    it 'returns low temperature' do
      expect(forecast.low).to be_a(Numeric)
    end
  end
end
