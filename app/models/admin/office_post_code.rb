module Admin
  class OfficePostCode < ApplicationRecord
    self.table_name = :office_post_codes

    belongs_to :office
  end
end
