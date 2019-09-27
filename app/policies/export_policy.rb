class ExportPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end

  end
  def create?
    user.is_admin? || user.permission_names.include?('create_exports')
  end

  def index?
    user.is_admin? || user.permission_names.include?('read_exports')
  end

  def show?
    user.is_admin? || user.permission_names.include?('read_exports')
  end

  def update?
    user.is_admin? || user.permission_names.include?('update_exports')
  end

  def destroy
    user.is_admin? || user.permission_names.include?('delete_exports')
  end
end
