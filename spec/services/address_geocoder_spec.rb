# spec/services/address_geocoder_spec.rb
require 'rails_helper'

RSpec.describe AddressGeocoder, :vcr do
  let(:valid_address) { '1600 Pennsylvania Ave NW, Washington, DC 20500' }
  let(:geocoder) { described_class.new(valid_address) }

  describe '#coordinates' do
    it 'returns latitude and longitude for valid address' do
      coordinates = geocoder.coordinates
      expect(coordinates).to be_an(Array)
      expect(coordinates.size).to eq(2)
      expect(coordinates[0]).to be_a(String)
      expect(coordinates[1]).to be_a(String)
    end

    context 'with invalid address' do
      let(:invalid_address) { 'asdfasdfasdfasdf' }
      let(:geocoder) { described_class.new(invalid_address) }

      it 'raises an error' do
        expect { geocoder.coordinates }.to raise_error(RuntimeError)
      end
    end
  end
end
