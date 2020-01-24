# frozen_string_literal: true
class ExportEvent < ApplicationRecord
  belongs_to :export

  scope :sub_case_exported, -> { where(message: 'Sub case exported') }
  scope :complete, -> { where(state: 'complete') }
  scope :in_progress, -> { where(state: 'in_progress') }
  scope :failed, -> { where(state: 'failed') }
  scope :erroring, -> { where(state: 'erroring') }
end
