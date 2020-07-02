class CommandPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end
  end

  def index?
    user.is_admin? || user.permission_names.include?('read_commands')
  end

  def show?
    user.is_admin? || user.permission_names.include?('read_commands')
  end

  def update?
    false
  end

  def destroy?
    false
  end

  def create?
    false
  end
end
