# frozen_string_literal: true
module Admin
  class ClaimClaimant < ApplicationRecord
    self.table_name = :claim_claimants
    belongs_to :claim
    belongs_to :claimant
  end
end