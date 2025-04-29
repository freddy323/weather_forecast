class ForecastsController < ApplicationController
  def new
    # Display form
  end

  def create
    address = params[:address]
    @address_service = AddressService.new(address)
    coordinates = @address_service.coordinates
    zip_code = coordinates[:zip_code]

    @cached = ForecastCacheService.cached?(zip_code)
    forecast_data = ForecastCacheService.fetch(zip_code)
    @forecast = ForecastPresenter.new(forecast_data, cached: @cached)

    render :show
  rescue AddressService::InvalidAddressError => e
    flash.now[:alert] = e.message
    render :new
  rescue => e
    flash.now[:alert] = "Unable to fetch weather data: #{e.message}"
    render :new
  end
end
