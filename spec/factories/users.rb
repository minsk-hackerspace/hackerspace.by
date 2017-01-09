FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@hackerspace.by" }
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    password "123456"
    password_confirmation "123456"
    # confirmed_at Time.now
    sign_in_count 0
    monthly_payment_amount 10

    factory :admin_user do
      after(:create) do |post|
        post.roles << FactoryGirl.create(:admin_role)
      end
    end
  end
end
