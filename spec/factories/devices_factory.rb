FactoryBot.define do
  factory :device do
    sequence(:name) { |n| "device_#{n}" }
    password { '111111' }
  end
end
