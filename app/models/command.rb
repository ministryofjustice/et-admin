# frozen_string_literal: true
class Command < ApplicationRecord
  self.table_name = :commands
  belongs_to :root_object, polymorphic: true
end
