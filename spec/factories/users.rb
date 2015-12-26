FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@hackerspace.by" }
    first_name { Forgery(:name).first_name }
    last_name { Forgery(:name).last_name }
    password "123456"
    password_confirmation "123456"
    confirmed_at Time.now

    factory :admin do
      admin true
    end
  end
end
