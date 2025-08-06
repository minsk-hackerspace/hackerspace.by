# == Schema Information
#
# Table name: events
#
#  id         :integer          not null, primary key
#  event_type :string
#  repeated   :boolean          default(FALSE)
#  value      :string
#  created_at :datetime
#  updated_at :datetime
#  device_id  :integer
#
FactoryBot.define do
  factory :event do
    event_type { 'light' }
    value { 'on' }
    device
  end
end