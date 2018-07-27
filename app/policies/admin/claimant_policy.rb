module Admin
  class ClaimantPolicy < ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def index?
      user.is_admin? || user.permission_names.include?('read_claimants')
    end

    def show?
      user.is_admin? || user.permission_names.include?('read_claimants')
    end

    def update?
      user.is_admin? || user.permission_names.include?('update_claimants')
    end

    def destroy
      user.is_admin? || user.permission_names.include?('delete_claimants')
    end
  end

end
