module Admin
  class RespondentPolicy < ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end

    end
    def index?
      user.is_admin? || user.permission_names.include?('read_respondent')
    end

    def show?
      user.is_admin? || user.permission_names.include?('read_respondent')
    end

    def update?
      user.is_admin? || user.permission_names.include?('update_respondent')
    end

    def destroy
      user.is_admin? || user.permission_names.include?('delete_respondent')
    end
  end

end
