module Admin
  class PermissionPolicy < ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def index?
      user.is_admin?
    end

    def show?
      user.is_admin?
    end

    def update?
      user.is_admin?
    end

    def delete?
      user.is_admin?
    end
  end
end
