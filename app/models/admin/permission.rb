module Admin
  class Admin::Permission < ApplicationRecord
    has_and_belongs_to_many :roles
  end
end
