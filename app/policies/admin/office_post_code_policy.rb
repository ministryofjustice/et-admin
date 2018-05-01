module Admin
  class OfficePostCodePolicy < ApplicationPolicy
    def index?
      true
    end

    def new?
      true
    end

    def show?
      true
    end

    def create?
      true
    end

    def edit?
      true
    end

    def destroy?
      true
    end

    def update?
      true
    end
  end
end
