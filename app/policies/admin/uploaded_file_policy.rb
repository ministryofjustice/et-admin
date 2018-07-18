module Admin
  class UploadedFilePolicy < ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def index?
      user.is_admin? || user.permission_names.include?('read_uploaded_file')
    end

    def show?
      user.is_admin? || user.permission_names.include?('read_uploaded_file')
    end

    def update?
      user.is_admin? || user.permission_names.include?('update_uploaded_file')
    end

    def destroy?
      user.is_admin? || user.permission_names.include?('delete_uploaded_file')
    end
  end

end
