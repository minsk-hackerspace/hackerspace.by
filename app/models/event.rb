# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  event_type :string
#  value      :string
#  device_id  :integer
#  created_at :datetime
#  updated_at :datetime
#  repeated   :boolean          default(FALSE)
#

class Event < ApplicationRecord
  belongs_to :device

  validates :event_type, :value, presence: true

  scope :light, -> { where event_type: 'light' }

  comma do
    id
    event_type
    value
    device_id
    created_at
    updated_at
  end

  def self.heatmap
    Rails.cache.fetch('heatmap', expires_in: 30.days) do
      h = Heatmap.new
      where(device_id: 1).find_in_batches(batch_size: 10_000) do |events|
        events.each do |event|
          if event.value == 'on'
            h.add_on_event(event.created_at)
          else
            h.add_off_event(event.created_at)
          end
        end
      end
      h
    end
  end
end
