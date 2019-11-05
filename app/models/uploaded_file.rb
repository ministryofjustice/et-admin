class UploadedFile < ApplicationRecord
  self.table_name = :uploaded_files
  has_one_attached :file

  scope :user_only, -> { where "filename LIKE '%.pdf' OR filename LIKE '%.rtf' OR filename LIKE '%.csv'" }
  def content_type
    file&.blob&.content_type
  end
end
