class Event < ActiveRecord::Base
  belongs_to :device

  validates :event_type, :value, presence: true

  scope :light, -> { where event_type: 'light'}
end
