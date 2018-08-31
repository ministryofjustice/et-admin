class UploadedFile < ApplicationRecord
  self.table_name = :uploaded_files
  has_one_attached :file
end
