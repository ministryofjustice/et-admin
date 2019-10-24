class ClaimPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def index?
    user.is_admin? || user.permission_names.include?('read_claims')
  end

  def show?
    user.is_admin? || user.permission_names.include?('read_claims')
  end

  def update?
    user.is_admin? || user.permission_names.include?('update_claims')
  end

  def destroy?
    user.is_admin? || user.permission_names.include?('delete_claims')
  end

  def export?
    user.is_admin? || user.permission_names.include?('create_exports')
  end
end
