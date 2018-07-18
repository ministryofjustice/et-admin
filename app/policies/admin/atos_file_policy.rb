module Admin
  class AtosFilePolicy < ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end

    end

    def show?
      user.is_admin? || user.permission_names.include?('read_atos_files')
    end

    def download?
      user.is_admin? || user.permission_names.include?('read_atos_files')
    end

    def index?
      user.is_admin? || user.permission_names.include?('read_atos_files')
    end

    def update?
      false
    end

    def destroy
      user.is_admin? || user.permission_names.include?('delete_atos_files')
    end
  end

end
