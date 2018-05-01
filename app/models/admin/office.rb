module Admin
  class Office < ApplicationRecord
    self.table_name = :offices

    has_many :office_post_codes

    validates :name, presence: true
    validates :code, presence: true
  end
end
