# == Schema Information
#
# Table name: users
#
#  id                       :integer          not null, primary key
#  email                    :string           default(""), not null
#  encrypted_password       :string           default(""), not null
#  reset_password_token     :string
#  reset_password_sent_at   :datetime
#  remember_created_at      :datetime
#  sign_in_count            :integer          default(0), not null
#  current_sign_in_at       :datetime
#  last_sign_in_at          :datetime
#  current_sign_in_ip       :string
#  last_sign_in_ip          :string
#  created_at               :datetime
#  updated_at               :datetime
#  hacker_comment           :string
#  photo_file_name          :string
#  photo_content_type       :string
#  photo_file_size          :integer
#  photo_updated_at         :datetime
#  first_name               :string
#  last_name                :string
#  bepaid_number            :integer
#  telegram_username        :string
#  alice_greeting           :string
#  last_seen_in_hackerspace :datetime
#  account_suspended        :boolean
#  account_banned           :boolean
#  monthly_payment_amount   :float            default(50.0)
#  github_username          :string
#  ssh_public_key           :text
#  is_learner               :boolean          default(FALSE)
#  project_id               :integer
#  guarantor1_id            :integer
#  guarantor2_id            :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_guarantor1_id         (guarantor1_id)
#  index_users_on_guarantor2_id         (guarantor2_id)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

require 'rails_helper'

describe User do
  describe "relations and validations" do
    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email).is_at_most(255) }
  end

  describe '#last_payment' do
    let(:user) { create :user }
    let!(:first_payment) { create :payment, paid_at: Date.parse('21-05-2018'), user: user }
    let!(:second_payment) { create :payment, paid_at: Date.parse('21-06-2018'), user: user }

    it 'is expected to return last paid payment' do
      expect(user.last_payment).to eq(second_payment)
    end
  end

  describe '.active' do
    let!(:blocked_user) { create :user, :banned }
    let!(:suspended_user) { create :user, :suspended }
    let!(:user_without_sign_in) { create :user, last_sign_in_at: nil }
    let!(:user_with_payment) { create :user, :with_payment }

    it 'is expected not to return blocked users' do
      expect(described_class.active).not_to include(blocked_user)
    end

    it 'is expected not to return suspended users' do
      expect(described_class.active).not_to include(suspended_user)
    end

    it 'is expected not to return users that never logged in' do
      expect(described_class.active).not_to include(user_without_sign_in)
    end

    it 'is expected to return users with payments' do
      expect(described_class.active).to include(user_with_payment)
    end
  end

  describe '.with_debt' do
    let!(:user_without_payment) { create :user }
    let!(:user_with_outdated_payment) { create :user, :with_outdated_payment }
    let!(:user_with_valid_payment) { create :user, :with_valid_payment }

    it 'is expected not to return users without payments' do
      expect(described_class.with_debt).not_to include(user_without_payment)
    end

    it 'is expected to return users with outdated payments' do
      expect(described_class.with_debt).to include(user_with_outdated_payment)
    end

    it 'is expected not to return users with valid payments' do
      expect(described_class.with_debt).not_to include(user_with_valid_payment)
    end
  end

  describe '#check_account_suspended' do
    let!(:user_with_valid_payment) { create :user, :with_valid_payment }
    let!(:user_with_outdated_payment) { create :user, :with_outdated_payment }

    it 'does nothing when valid payment'  do
      expect{user_with_valid_payment.set_as_suspended}.not_to change{user_with_valid_payment.account_suspended}.from(nil)
    end

    it 'suspends nothing when invalid payment'  do
      expect{user_with_outdated_payment.set_as_suspended}.to change{user_with_outdated_payment.account_suspended}.from(nil).to(true)
    end
  end
end
