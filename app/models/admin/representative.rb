module Admin
  class Representative < ApplicationRecord
    self.table_name = :representatives
    belongs_to :address
    accepts_nested_attributes_for :address
  end
end