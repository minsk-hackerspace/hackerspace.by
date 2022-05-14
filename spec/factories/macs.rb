FactoryBot.define do
  factory :mac do
    sequence(:address) { |n| "fake_mac_address#{n}" }
    user
  end
end
