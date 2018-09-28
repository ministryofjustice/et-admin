module Admin
  class RolePolicy < ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        if user.is_admin?
          scope.all
        else
          scope.where(is_admin: false)
        end
      end
    end

    def create?
      user.is_admin? || user.permission_names.include?('create_roles')
    end

    def show?
      user.is_admin? || user.permission_names.include?('read_roles')
    end

    def index?
      # true
      user.is_admin? || user.permission_names.include?('read_roles')
    end

    def update?
      user.is_admin? || user.permission_names.include?('update_roles')
    end

    def destroy?
      user.is_admin? || user.permission_names.include?('delete_roles')
    end
  end
end
