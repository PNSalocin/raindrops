module Raindrops
  class DownloadSerializer < ActiveModel::Serializer
    attributes :id, :source_url, :destination_path, :file_size,
               :status, :error_content, :created_at, :updated_at
  end
end