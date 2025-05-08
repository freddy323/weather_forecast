# frozen_string_literal: true

class ForecastsController < ApplicationController # rubocop:disable Style/Documentation
  def show
    @address = params[:address]
    return unless @address.present?

    begin
      zip_code = extract_zip_code(@address)
      cache_key = "forecast_#{zip_code}"
      @cached = Rails.cache.exist?(cache_key)

      @forecast = Rails.cache.fetch(cache_key, expires_in: 30.minutes) do
        Forecast.new(@address).fetch
      end

      # Set time zone for display purposes
      Time.zone = @forecast.time_zone
    rescue StandardError => e
      flash[:error] = "Error retrieving forecast: #{e.message}"
      Rails.logger.error "Forecast error: #{e.message}\n#{e.backtrace.join("\n")}"
    end
  end

  private

  def extract_zip_code(address)
    address.match(/\b\d{5}(?:-\d{4})?\b/)&.to_s || 'unknown'
  end
end
