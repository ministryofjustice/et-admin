# frozen_string_literal: true
module Admin
  class Respondent < ApplicationRecord
    self.table_name = :respondents
    belongs_to :address
    belongs_to :work_address, class_name: 'Address', required: false
    accepts_nested_attributes_for :address
    accepts_nested_attributes_for :work_address
  end
end