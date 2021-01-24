class ShortUrl < ApplicationRecord
  validates :random_hex,
            uniqueness: true
  validates :random_hex,
            presence: true
  validates :original_url,
            presence: true,
            if: -> { child_short_url_id.nil? }
  validates :original_url,
            url: true,
            if: -> { child_short_url_id.nil? }

  belongs_to :child_short_url,
             foreign_key: 'child_short_url_id',
             class_name: 'ShortUrl',
             optional: true
end
