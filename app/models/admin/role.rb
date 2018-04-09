module Admin
  class Role < ApplicationRecord
    self.table_name = :admin_roles
    has_many :user_roles
    has_many :role_permissions
    has_many :users, through: :user_roles
    has_many :permissions, through: :role_permissions

    before_save :cache_permissions

    private

    def cache_permissions
      self.permission_names = permissions.map(&:name)
    end
  end
end