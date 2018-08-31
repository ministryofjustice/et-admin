module Admin
  class OfficePostCodePolicy < ApplicationPolicy
    def create?
      user.is_admin? || user.permission_names.include?('create_office_postcodes')
    end

    def index?
      user.is_admin? || user.permission_names.include?('read_office_postcodes')
    end

    def show?
      user.is_admin? || user.permission_names.include?('read_office_postcodes')
    end

    def update?
      user.is_admin? || user.permission_names.include?('update_office_postcodes')
    end

    def destroy?
      user.is_admin? || user.permission_names.include?('delete_office_postcodes')
    end
  end
end
