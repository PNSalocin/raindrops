class CreateRaindropsDownloads < ActiveRecord::Migration #:nodoc:
  def change #:nodoc:
    create_table :raindrops_downloads do |t|
      t.string :source_url, limit: 255, null: false
      t.string :destination_path, limit: 255, null: false
      t.integer :file_size, null: false, default: 1
      t.integer :status, null: false, default: 0
      t.string :error_content, limit: 250
      t.timestamps null: false
    end
  end
end
