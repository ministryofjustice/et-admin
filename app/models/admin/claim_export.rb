# frozen_string_literal: true
module Admin
  class ClaimExport < ApplicationRecord
    self.table_name = :claim_exports
    belongs_to :claim
    belongs_to :pdf_file, class_name: 'Admin::UploadedFile', optional: true
  end
end