module Admin
  class UserPolicy < ApplicationPolicy
    def index?
      user.is_admin?
    end

    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def show?
      true
    end

    def update?
      user.is_admin?
    end
  end
end
