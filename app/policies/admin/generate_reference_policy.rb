module Admin
  class GenerateReferencePolicy < ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def index?
      user.is_admin? || user.permission_names.include?('create_reference_number_generators')
    end

    def create?
      user.is_admin? || user.permission_names.include?('create_reference_number_generators')
    end

    def show?
      user.is_admin? || user.permission_names.include?('create_reference_number_generators')
    end

    def update?
      false
    end

    def destroy?
      false
    end

  end

end
