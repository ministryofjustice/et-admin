module Admin
  class GenerateReference
    include ActiveModel::Model

    attr_accessor :postcode, :reference

    def self.inheritance_column
      :type
    end

    def self.columns
      []
    end

    def self.base_class
      self
    end
  end
end