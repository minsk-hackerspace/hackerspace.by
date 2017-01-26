FactoryGirl.define do

  factory :role do
    factory :admin_role do
      name 'admin'
    end

    factory :hacker_role do
      name 'hacker'
    end
  end

end
