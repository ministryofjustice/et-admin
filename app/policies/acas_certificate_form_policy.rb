class AcasCertificateFormPolicy < ApplicationPolicy
  class Scope < Struct.new(:user, :scope)
    def resolve
      scope
    end

  end

  def show?
    user.is_admin? || user.permission_names.include?('read_acas')
  end

  def index?
    false
  end

  def update?
    false
  end

  def destroy
    false
  end
end
