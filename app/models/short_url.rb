class ShortUrl < ApplicationRecord
  validates :random_hex,   uniqueness: true
  validates :original_url, presence: true
  validates :random_hex,   presence: true
  validates :original_url, url: true
end
