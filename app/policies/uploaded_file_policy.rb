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

  def create?
    user.is_admin? || user.permission_names.include?('create_uploaded_file')
  end

  def export_ccd_multiples?
    user.is_admin?
  end

  def delete_file_from_storage?
    user.is_admin?
  end
end
