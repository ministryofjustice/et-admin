# frozen_string_literal: true
class ExportEvent < ApplicationRecord
  belongs_to :export

  scope :sub_case_exported, -> { where(message: 'Sub case exported') }
end
