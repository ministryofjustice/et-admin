# frozen_string_literal: true
module Admin
  class UserRole < ApplicationRecord
    belongs_to :user
    belongs_to :role
  end
end