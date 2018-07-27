# frozen_string_literal: true

module Admin
  class Claimant < ApplicationRecord
    self.table_name = :claimants
    belongs_to :address
    accepts_nested_attributes_for :address
    def name
      "#{title} #{first_name} #{last_name}"
    end
  end
end