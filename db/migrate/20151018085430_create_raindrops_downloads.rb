class CreateRaindropsDownloads < ActiveRecord::Migration
  def change
    create_table :raindrops_downloads do |t|
      t.string :source_url, limit: 255
      t.string :destination_path, limit: 255
      t.integer :file_total_size
      t.integer :file_downloaded_size
      t.timestamps null: false
    end
  end
end
