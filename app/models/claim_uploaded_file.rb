class ClaimUploadedFile < ApplicationRecord
  self.table_name = :claim_uploaded_files
  belongs_to :claim
  belongs_to :uploaded_file
end
