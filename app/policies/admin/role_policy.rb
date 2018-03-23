module Admin
  class RolePolicy < ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def show?
      true
    end
  end
end
