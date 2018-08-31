# frozen_string_literal: true
class ClaimRespondent < ApplicationRecord
  self.table_name = :claim_respondents
  belongs_to :claim
  belongs_to :respondent
end
