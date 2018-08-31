class OfficePostCode < ApplicationRecord
  self.table_name = :office_post_codes

  belongs_to :office

  validates :postcode, presence: true, uniqueness: true

  def to_s
    postcode
  end
end
