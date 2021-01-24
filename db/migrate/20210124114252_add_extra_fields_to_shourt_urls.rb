class AddExtraFieldsToShourtUrls < ActiveRecord::Migration[6.0]
  def change
    add_column :short_urls, :number_of_times_accessed, :integer, default: 0
    add_column :short_urls, :disabled, :boolean, default: false
  end
end
