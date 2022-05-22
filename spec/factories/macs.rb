# == Schema Information
#
# Table name: macs
#
#  id      :integer          not null, primary key
#  address :string
#  user_id :integer
#
# Indexes
#
#  index_macs_on_address  (address)
#  index_macs_on_user_id  (user_id)
#
FactoryBot.define do
  factory :mac do
    sequence(:address) { |n| "fake_mac_address#{n}" }
    user
  end
end
