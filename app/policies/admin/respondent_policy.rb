module Admin
  class RespondentPolicy < ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end

    end
    def index?
      true
    end

    def update?
      false
    end

    def destroy
      false
    end
  end

end
