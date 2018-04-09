module Admin
  class User < ApplicationRecord
    self.table_name = :admin_users
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable,
      :recoverable, :rememberable, :trackable, :validatable

    has_many :user_roles, class_name: 'Admin::UserRole'
    has_many :roles, class_name: 'Admin::Role', through: :user_roles
    has_many :permissions, class_name: 'Admin::Permission', through: :roles

    before_save :cache_permissions

    private

    def cache_permissions(*)
      self.permission_names = roles.map(&:permission_names).flatten.uniq
      self.is_admin = roles.any?(&:is_admin?)
    end
  end
end
