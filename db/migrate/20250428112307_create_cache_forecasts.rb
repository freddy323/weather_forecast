class CreateCacheForecasts < ActiveRecord::Migration[8.0]
  def change
    create_table :cache_forecasts do |t|
      t.string :zip_code
      t.json :data
      t.datetime :expires_at

      t.timestamps
    end
  end
end
