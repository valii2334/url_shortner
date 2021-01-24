class AddIndexToShortUrls < ActiveRecord::Migration[6.0]
  def change
    add_index :short_urls, :random_hex, unique: true
  end
end
