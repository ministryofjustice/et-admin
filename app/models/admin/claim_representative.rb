module Admin
  class ClaimRepresentative < ApplicationRecord
    self.table_name = :claim_representatives
    belongs_to :claim
    belongs_to :representative
  end
end