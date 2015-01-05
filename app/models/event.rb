class Event < ActiveRecord::Base
  belongs_to :device
  validates :event_type, presence: { strict: true }
  validates :value, presence: { strict: true }
end
