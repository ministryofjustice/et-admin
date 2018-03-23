module Admin
  class User < ApplicationRecord
    self.table_name = :admin_users
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable,
      :recoverable, :rememberable, :trackable, :validatable

    has_and_belongs_to_many :roles, class_name: 'Admin::Role'
  end
end
