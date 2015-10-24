json.products @downloads do |download|
  json.id download.id
  json.source_url download.source_url
  json.destination_path download.destination_path
  json.file_total_size download.file_total_size
  json.file_downloaded_size download.file_downloaded_size
  json.completed download.completed
  json.created_at download.created_at
  json.updated_at download.updated_at
end