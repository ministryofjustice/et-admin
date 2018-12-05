class ExternalSystemPolicy < ApplicationPolicy
  def create?
    user.is_admin? || user.permission_names.include?('create_external_systems')
  end

  def index?
    user.is_admin? || user.permission_names.include?('read_external_systems')
  end

  def show?
    user.is_admin? || user.permission_names.include?('read_external_systems')
  end

  def update?
    user.is_admin? || user.permission_names.include?('update_external_systems')
  end

  def destroy?
    user.is_admin? || user.permission_names.include?('delete_external_systems')
  end
end
