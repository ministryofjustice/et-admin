class DefaultOfficeClaimPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def index?
    user.is_admin? || user.permission_names.include?('read_default_office_claims')
  end

  def show?
    user.is_admin? || user.permission_names.include?('read_default_office_claims')
  end

  def update?
    false
  end

  def destroy?
    false
  end

  def assign?
    user.is_admin? || user.permission_names.include?('assign_default_office_claims')
  end
end
