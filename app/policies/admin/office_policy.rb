module Admin
  class OfficePolicy < ApplicationPolicy
    def index?
      user.is_admin? || user.permission_names.include?('read_offices')
    end

    def show?
      user.is_admin? || user.permission_names.include?('read_offices')
    end

    def update?
      user.is_admin? || user.permission_names.include?('update_offices')
    end

    def destroy
      user.is_admin? || user.permission_names.include?('delete_offices')
    end

  end
end
