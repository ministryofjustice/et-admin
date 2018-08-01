module Admin
  class RespondentPolicy < ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end

    end
    def index?
      user.is_admin? || user.permission_names.include?('read_respondents')
    end

    def show?
      user.is_admin? || user.permission_names.include?('read_respondents')
    end

    def update?
      user.is_admin? || user.permission_names.include?('update_respondents')
    end

    def destroy
      user.is_admin? || user.permission_names.include?('delete_respondents')
    end
  end

end
