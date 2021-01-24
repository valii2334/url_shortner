FactoryBot.define do
  factory :short_url do
    random_hex { SecureRandom.hex(4) }
    original_url { FFaker::Internet.uri('https') }
  end
end
