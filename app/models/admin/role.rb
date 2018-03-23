module Admin
  class Role < ApplicationRecord
    self.table_name = :admin_roles
    has_and_belongs_to_many :users
    has_and_belongs_to_many :permissions
  end
end