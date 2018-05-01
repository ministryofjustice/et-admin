module Admin
  class OfficePostCode < ApplicationRecord
    self.table_name = :office_post_codes

    belongs_to :office

    validates :postcode, presence: true

    def to_s
      postcode
    end
  end
end
