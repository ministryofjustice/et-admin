# frozen_string_literal: true
module Admin
  class ClaimRespondent < ApplicationRecord
    self.table_name = :claim_respondents
    belongs_to :claim
    belongs_to :respondent
  end
end