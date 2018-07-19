module Admin
  class UserPolicy < ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def create?
      user.is_admin? || user.permission_names.include?('create_users')
    end

    def index?
      user.is_admin? || user.permission_names.include?('read_users')
    end

    def show?
      user.is_admin? || user.permission_names.include?('read_users')
    end

    def update?
      user.is_admin? || user.permission_names.include?('update_users')
    end

    def destroy?
      user.is_admin? || user.permission_names.include?('delete_users')
    end

    def import?
      user.is_admin? || user.permission_names.include?('import_users')
    end
  end
end
