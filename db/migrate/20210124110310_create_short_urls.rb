class CreateShortUrls < ActiveRecord::Migration[6.0]
  def change
    create_table :short_urls do |t|
      t.string :random_hex, null: false
      t.text :original_url, null: false
      
      t.integer :admin_short_url_id

      t.timestamps
    end
  end
end
