module Admin
  class AcasDownloadLogPolicy < ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end

    end

    def index?
      user.is_admin? || user.permission_names.include?('read_acas_download_logs')
    end

    def show?
      user.is_admin? || user.permission_names.include?('read_acas_download_logs')
    end

    def update?
      false
    end

    def destroy
      false
    end
  end

end
