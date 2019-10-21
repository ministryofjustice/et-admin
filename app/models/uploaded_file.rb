class UploadedFile < ApplicationRecord
  self.table_name = :uploaded_files
  has_one_attached :file

  def content_type
    file&.blob&.content_type
  end
end
