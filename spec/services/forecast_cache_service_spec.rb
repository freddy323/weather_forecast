require 'rails_helper'

RSpec.describe ForecastCacheService do
  let(:zip_code) { "10001" }
  let(:expired_time) { 31.minutes.ago }
  let(:forecast_data) { { current: { temp_f: 72.0 } } }

  before do
    CacheForecast.where(zip_code: zip_code).destroy_all
  end

  describe "#fetch" do
    context "when no cached data exists" do
      it "creates a new cache entry" do
        expect {
          described_class.new(zip_code).fetch
        }.to change(CacheForecast, :count).by(1)
      end
    end

    context "when valid cached data exists" do
      before do
        create(:cache_forecast, zip_code: zip_code, data: forecast_data)
      end

      it "returns cached data without creating new entry" do
        expect {
          described_class.new(zip_code).fetch
        }.not_to change(CacheForecast, :count)
      end
    end
  end

  describe "#cached?" do
    context "when fresh cache exists" do
      before { create(:cache_forecast, zip_code: zip_code) }

      it "returns true" do
        expect(described_class.new(zip_code).cached?).to be true
      end
    end

    context "when no cache exists" do
      it "returns false" do
        expect(described_class.new(zip_code).cached?).to be false
      end
    end
  end

  describe ".cached?" do
    context "when fresh cache exists" do
      before { create(:cache_forecast, zip_code: zip_code) }

      it "returns true" do
        expect(described_class.cached?(zip_code)).to be true
      end
    end

    context "when no cache exists" do
      it "returns false" do
        expect(described_class.cached?(zip_code)).to be false
      end
    end
  end
end
