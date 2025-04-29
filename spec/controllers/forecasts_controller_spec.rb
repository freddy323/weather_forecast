require 'rails_helper'

RSpec.describe ForecastsController, type: :controller do
  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    let(:forecast_data) do
      {
        current: {
          temp_f: 72.0,
          condition: { text: "Sunny" },
          humidity: 45,
          wind_mph: 3.2
        },
        forecast: {
          forecastday: [ {
            day: {
              maxtemp_f: 78.3,
              mintemp_f: 65.2,
              condition: { text: "Sunny" }
            }
          } ]
        }
      }
    end

    context "with valid address" do
      before do
        allow_any_instance_of(AddressService).to receive(:coordinates)
          .and_return({ zip_code: '10001' })
        allow(ForecastCacheService).to receive(:fetch)
          .and_return(forecast_data)
        post :create, params: { address: "123 Main St, New York, NY 10001" }
      end

      it "renders the show template" do
        expect(response).to render_template(:show)
      end
    end

    context "with invalid address" do
      before do
        allow_any_instance_of(AddressService).to receive(:coordinates)
          .and_raise(AddressService::InvalidAddressError, "Invalid address")
        post :create, params: { address: "No zip code" }
      end

      it "renders new template" do
        expect(response).to render_template(:new)
      end
    end
  end
end
