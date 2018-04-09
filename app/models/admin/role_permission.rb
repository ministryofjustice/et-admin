# frozen_string_literal: true
module Admin
  class RolePermission < ApplicationRecord
    belongs_to :role
    belongs_to :permission
  end
end