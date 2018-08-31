# frozen_string_literal: true
class ClaimClaimant < ApplicationRecord
  self.table_name = :claim_claimants
  belongs_to :claim
  belongs_to :claimant
end
