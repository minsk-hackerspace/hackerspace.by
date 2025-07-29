# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  account_banned           :boolean
#  account_suspended        :boolean
#  alice_greeting           :string
#  bepaid_number            :integer
#  current_sign_in_at       :datetime
#  current_sign_in_ip       :string
#  email                    :string           default(""), not null
#  encrypted_password       :string           default(""), not null
#  first_name               :string
#  github_username          :string
#  hacker_comment           :string
#  is_learner               :boolean          default(FALSE)
#  last_name                :string
#  last_seen_in_hackerspace :datetime
#  last_sign_in_at          :datetime
#  last_sign_in_ip          :string
#  photo_content_type       :string
#  photo_file_name          :string
#  photo_file_size          :integer
#  photo_updated_at         :datetime
#  remember_created_at      :datetime
#  reset_password_sent_at   :datetime
#  reset_password_token     :string
#  sign_in_count            :integer          default(0), not null
#  suspended_changed_at     :datetime         default(2010-12-31 20:21:50.000000000 EET +02:00), not null
#  tariff_changed_at        :datetime
#  telegram_username        :string
#  tg_auth_token            :string
#  tg_auth_token_expiry     :datetime
#  created_at               :datetime
#  updated_at               :datetime
#  guarantor1_id            :integer
#  guarantor2_id            :integer
#  project_id               :integer
#  tariff_id                :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_guarantor1_id         (guarantor1_id)
#  index_users_on_guarantor2_id         (guarantor2_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_tariff_id             (tariff_id)
#
# Foreign Keys
#
#  tariff_id  (tariff_id => tariffs.id)
#

FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@hackerspace.by" }
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    password {"123456"}
    password_confirmation {"123456"}
    suspended_changed_at {DateTime.now}
    tariff
    # confirmed_at Time.now
    sign_in_count {0}

    trait :banned do
      account_banned {true}
    end

    trait :suspended do
      account_suspended {true}
    end

    trait :with_payment do
      after(:create) do |user|
        user.payments << create(:payment)
      end
    end

    trait :with_outdated_payment do
      last_sign_in_at {Time.now - 2.days}
      after(:create) do |user|
        user.payments << create(:payment, :outdated)
      end
    end

    trait :expires_in_2_days do
      last_sign_in_at {Time.now - 2.days}
      after(:create) do |user|
        user.payments << create(:payment, :expires_in_2_days)
      end
    end

    trait :with_valid_payment do
      after(:create) do |user|
        user.payments << create(:payment, end_date: Date.today + 10.days)
      end
    end

    factory :admin_user do
      after(:create) do |post|
        post.roles << FactoryBot.create(:admin_role)
      end
    end
  end
end
