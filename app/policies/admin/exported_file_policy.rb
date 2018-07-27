module Admin
  class ExportedFilePolicy < ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end

    end
    def index?
      user.is_admin? || user.permission_names.include?('read_exported_files')
    end

    def show?
      user.is_admin? || user.permission_names.include?('read_exported_files')
    end

    def update?
      user.is_admin? || user.permission_names.include?('update_exported_files')
    end

    def destroy
      user.is_admin? || user.permission_names.include?('delete_exported_files')
    end
  end

end
