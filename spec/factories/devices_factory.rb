# == Schema Information
#
# Table name: devices
#
#  id                 :integer          not null, primary key
#  encrypted_password :string           not null
#  name               :string           not null
#  created_at         :datetime
#  updated_at         :datetime
#
FactoryBot.define do
  factory :device do
    sequence(:name) { |n| "device_#{n}" }
    password { '111111' }
  end
end
