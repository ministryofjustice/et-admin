# frozen_string_literal: true
module Admin
  class Export < ApplicationRecord
    self.table_name = :exports
    belongs_to :resource, polymorphic: true
    belongs_to :pdf_file, class_name: 'Admin::UploadedFile', optional: true
  end
end
