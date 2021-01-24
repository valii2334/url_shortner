class ShortUrl < ApplicationRecord
  validates :random_hex,
            uniqueness: true
  validates :random_hex,
            presence: true
  validates :original_url,
            presence: true,
            if: -> { child_short_url_id.nil? }

  belongs_to :child_short_url,
             foreign_key: 'child_short_url_id',
             class_name: 'ShortUrl',
             optional: true

  has_one :parent_short_url,
          foreign_key: 'child_short_url_id',
          class_name: 'ShortUrl'

  def admin_url?
    child_short_url.present?
  end

  def increase_number_of_times_accessed!
    ShortUrl.transaction do
      lock!
      self.number_of_times_accessed += 1
      save!
    end
  end
end
