module Admin
  class OfficePolicy < ApplicationPolicy
    def index?
      true
    end

    def show?
      false
    end
  end
end
