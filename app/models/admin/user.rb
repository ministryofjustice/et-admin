module Admin
  class User < ApplicationRecord
    before_validation :strip_username_whitespace
    validates :username, presence: true, uniqueness: true,
                         length: { minimum: 4, maximum: 30 }, username: true
    validates :name, :department, :role_ids, presence: true, on: :create
    self.table_name = :admin_users
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable,
      :recoverable, :rememberable, :trackable, :validatable, :lockable, :timeoutable

    has_many :user_roles, class_name: 'Admin::UserRole'
    has_many :roles, class_name: 'Admin::Role', through: :user_roles
    has_many :permissions, class_name: 'Admin::Permission', through: :roles

    before_save :cache_permissions


    private

    def cache_permissions(*)
      self.permission_names = roles.map(&:permission_names).flatten.uniq.compact
      self.is_admin = roles.any?(&:is_admin?)
    end

    def strip_username_whitespace
      self.username = username.strip
    end
  end
end
