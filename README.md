# Weather Forecast Application

![Weather App Screenshot](app/assets/images/screenshot.png) <!-- Add a screenshot if available -->

A Ruby on Rails application that retrieves and displays weather forecasts for any given US address.

## Features

- **Address-based Weather Lookup**: Enter any US address containing a zip code
- **Comprehensive Forecast Data**:
  - Current temperature and conditions
  - High/low temperatures
  - Wind speed and direction
  - Precipitation probability
  - Detailed textual forecast
- **Intelligent Caching**: 
  - 30-minute cache by zip code
  - Visual cache status indicator
- **Responsive Design**: Works on all device sizes
- **Error Handling**: User-friendly error messages

## Technology Stack

- **Framework**: Ruby on Rails 7
- **Database**: PostgreSQL
- **APIs**:
  - Nominatim (OpenStreetMap) for geocoding
  - National Weather Service (NWS) for weather data
- **Frontend**:
  - Bootstrap 5 for responsive layout
  - Font Awesome for icons
- **Testing**:
  - RSpec
  - VCR for API test recording

## Setup Instructions

### Prerequisites

- Ruby 3.x
- Rails 7.x
- PostgreSQL
- Bundler

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/freddy323/weather-forecast.git
   cd weather-forecast
2. Install dependencies: `bundle install`
3. Set up database: `rails db:create db:migrate`
4. Start the server: `rails s`
5. Run the app `http://localhost:3000/forecast`

## Testing

Run the test suite with: `bundle exec rspec`

## Implementation Details

### Services

- `AddressGeocoder`: Get the coordinates through the nomination API
- `WeatherService`: Interfaces with weather API

### Caching

Forecast data is cached in the database using the `Rails Cache` with an expiration time of 30 minutes.

### API Rate Limits

- Nominatim (Geocoding): 1 request per second
- NWS (Weather): 10 requests per minute
- The application automatically handles these limits with:
- Request throttling
- Intelligent caching
- Graceful error handling


