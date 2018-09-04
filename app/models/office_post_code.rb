class OfficePostCode < ApplicationRecord
  self.table_name = :office_post_codes

  belongs_to :office

  validates :postcode, presence: true
  validates_uniqueness_of :postcode, case_sensitive: false

  def to_s
    postcode
  end
end
