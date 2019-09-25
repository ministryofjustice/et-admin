# frozen_string_literal: true
class Export < ApplicationRecord
  self.table_name = :exports
  belongs_to :resource, polymorphic: true
  belongs_to :external_system
end
