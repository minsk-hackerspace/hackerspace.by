# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  event_type :string(255)
#  value      :string(255)
#  device_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Event < ApplicationRecord
  belongs_to :device

  validates :event_type, :value, presence: true

  scope :light, -> { where event_type: 'light'}

  comma do
    id
    event_type
    value
    device_id
    created_at
    updated_at
  end

end
