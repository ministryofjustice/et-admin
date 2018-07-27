module ActiveAdmin
  class PagePolicy < ApplicationPolicy
    class Scope < Struct.new(:user, :scope)
      def resolve
        scope
      end
    end

    def show?
      case record.name
      when 'Dashboard'
        true
      when 'Jobs'
        user.is_admin? || user.permission_names.include?('read_jobs')
      when 'Acas'
        user.is_admin? || user.permission_names.include?('read_acas')
      when 'Certificate Search'
        user.is_admin? || user.permission_names.include?('read_acas')
      else
        user.is_admin?
      end
    end
  end
end
