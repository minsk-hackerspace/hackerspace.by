# == Schema Information
#
# Table name: roles
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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
