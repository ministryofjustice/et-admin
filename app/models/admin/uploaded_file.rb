module Admin
  class UploadedFile < ApplicationRecord
    self.table_name = :uploaded_files
  end
end