# frozen_string_literal: true
module Admin
  class Response < ApplicationRecord
    self.table_name = :responses

    belongs_to :respondent
  end
end