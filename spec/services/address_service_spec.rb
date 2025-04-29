require 'rails_helper'

RSpec.describe AddressService do
  let(:valid_address) { "123 Main St, New York, NY 10001" }
  let(:invalid_address) { "No zip code here" }
  let(:empty_address) { "" }

  describe "#coordinates" do
    context "with valid address containing zip code" do
      subject { described_class.new(valid_address).coordinates }

      it "extracts the zip code" do
        expect(subject[:zip_code]).to eq("10001")
      end
    end

    context "with empty address" do
      it "raises InvalidAddressError" do
        expect { described_class.new(empty_address).coordinates }.to raise_error(
          AddressService::InvalidAddressError,
          "Address cannot be blank"
        )
      end
    end

    context "with address missing zip code" do
      it "raises InvalidAddressError" do
        expect { described_class.new(invalid_address).coordinates }.to raise_error(
          AddressService::InvalidAddressError,
          "No valid zip code found"
        )
      end
    end
  end
end
