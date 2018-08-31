class RepresentativePolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end

  end
  def index?
    user.is_admin? || user.permission_names.include?('read_representatives')
  end

  def show?
    user.is_admin? || user.permission_names.include?('read_representatives')
  end

  def update?
    user.is_admin? || user.permission_names.include?('update_representatives')
  end

  def destroy
    user.is_admin? || user.permission_names.include?('delete_representatives')
  end
end
