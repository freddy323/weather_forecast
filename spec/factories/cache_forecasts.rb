FactoryBot.define do
  factory :cache_forecast do
    zip_code { Faker::Address.zip_code }
    data { { current: { temp_f: rand(30..100) } } }
    expires_at { 30.minutes.from_now }
  end
end
