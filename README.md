# Weather Forecast Application

A Ruby on Rails application that retrieves and displays weather forecasts for a given address.

## Features

- Accepts an address as input (must contain a US zip code)
- Retrieves current weather conditions and daily forecast
- Caches forecast data for 30 minutes by zip code
- Displays whether the result was pulled from cache

## Setup

1. Clone the repository
2. Install dependencies: `bundle install`
3. Set up database: `rails db:create db:migrate`
4. Start the server: `rails s`

## Testing

Run the test suite with: `bundle exec rspec`

## Implementation Details

### Services

- `AddressService`: Handles address validation and zip code extraction
- `WeatherService`: Interfaces with weather API (mock implementation in this example)
- `ForecastCacheService`: Manages 30-minute caching of forecast data by zip code

### Presenter

- `ForecastPresenter`: Formats weather data for display in views

### Caching

Forecast data is cached in the database using the `CacheForecast` model with an expiration time of 30 minutes.
