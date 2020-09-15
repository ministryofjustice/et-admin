class Event < ApplicationRecord
  belongs_to :attached_to, polymorphic: true
end
