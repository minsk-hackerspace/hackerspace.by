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

require 'rails_helper'

describe User, type: :model  do
  describe "relations and validations" do
    let(:user) { create :user }

    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email).is_at_most(255) }

    it 'has default tariff' do
      expect(user.tariff).not_to be_blank
    end
  end

  describe '.telegram_username' do
    let(:user) { create :user, telegram_username: "@test" }
    it 'should not to include @' do
      user.validate
      expect(user.telegram_username).to eq('test')
    end
  end

  describe '.telegram_username_link' do
    let(:user) { create :user, telegram_username: "@test" }
    it 'should not to include @' do
      user.validate
      expect(user.telegram_username_link).to eq("https://t.me/#{user.telegram_username}")
    end
  end

  describe '#last_payment' do
    let(:user) { create :user }
    let!(:first_payment) { create :payment, paid_at: DateTime.parse('12:00 21-05-2018'), user: user }
    let!(:second_payment) { create :payment, paid_at: DateTime.parse('13:00 21-06-2018'), user: user }

    it 'is expected to return last paid payment' do
      expect(user.last_payment).to eq(second_payment)
    end
  end

  describe '.allowed_paid_or_signed_in' do
    let!(:blocked_user) { create :user, :banned }
    let!(:suspended_user) { create :user, :suspended }
    let!(:user_without_sign_in) { create :user, last_sign_in_at: nil }
    let!(:user_with_payment) { create :user, :with_payment }

    it 'is expected not to return blocked users' do
      expect(described_class.allowed_paid_or_signed_in).not_to include(blocked_user)
    end

    it 'is expected not to return suspended users' do
      expect(described_class.allowed_paid_or_signed_in).not_to include(suspended_user)
    end

    it 'is expected not to return users that never logged in' do
      expect(described_class.allowed_paid_or_signed_in).not_to include(user_without_sign_in)
    end

    it 'is expected to return users with payments' do
      expect(described_class.allowed_paid_or_signed_in).to include(user_with_payment)
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

  describe '.fee_expires_in' do
    let!(:user_with_outdated_payment2) { create :user, :with_outdated_payment }

    it 'is expected to not return empty dataset' do
      expect(described_class.fee_expires_in(0.days)).to_not be_empty
    end

    it 'is expected to return users with outdated payments' do
      expect(described_class.with_debt).to include(user_with_outdated_payment2)
    end
  end

  describe "#access_allowed?" do
    context 'for active user' do
      let(:access_allowed_tariff) { create :tariff, access_allowed: true }
      let(:user_with_valid_payment) { create :user, :with_valid_payment, tariff: access_allowed_tariff }

      it 'returns true' do
        expect(user_with_valid_payment.access_allowed?).to be true
      end
    end

    context 'for inactive user' do
      let(:access_not_allowed_tariff) { create :tariff, access_allowed: false }
      let(:user_with_valid_payment) { create :user, :with_valid_payment, tariff: access_not_allowed_tariff }

      it 'returns false' do
        expect(user_with_valid_payment.access_allowed?).to be false
      end
    end
  end

  describe '#set_as_suspended' do
    let!(:user_with_valid_payment) { create :user, :with_valid_payment }
    let!(:user_with_outdated_payment) { create :user, :with_outdated_payment }

    it 'does nothing when valid payment'  do
      expect{user_with_valid_payment.set_as_suspended}.not_to change{user_with_valid_payment.account_suspended}.from(nil)
    end

    it 'suspends nothing when invalid payment'  do
      expect{user_with_outdated_payment.set_as_suspended}.to change{user_with_outdated_payment.account_suspended}.from(nil).to(true)
    end
  end

  describe "tariff changes logic" do
    let(:user) { create :user }
    let(:admin) { create :admin_user }
    let(:tariff) { create :tariff }

    context "user" do
      it 'updates one time per 30 days' do
        user.update(tariff_changed_at: Time.now - 32.days)
        user.updating_by = user
        user.tariff = tariff

        expect(user).to be_valid
      end

      it "not updates if tariff was changed less then #{Tariff::CHANGE_LIMIT_IN_DAYS} days ago" do
        user.updating_by = user
        user.tariff = tariff

        expect(user).to_not be_valid
      end

      context "allow updates if tariff was not changed" do
        let!(:user) { create(:user) }

        subject { user }

        before do
          user.updating_by = user
          user.tariff_changed_at = Time.now
          user.updating_by = user
          user.first_name = 'test123'
        end

        it { expect(subject).to be_valid }
      end
    end

    context "admin" do
      it 'always does updates' do
        user.updating_by = admin
        user.tariff = tariff

        expect(user).to be_valid
      end
    end

    context "sustem" do
      it 'always does updates' do
        user.updating_by = admin
        user.tariff = tariff

        expect(user).to be_valid
      end
    end
  end

  describe '#update_bepaid_bill' do
    let(:user) { create :user }
    let(:tariff) { create :tariff }

    it 'invokes update_bepaid_bill on create' do
      new_user = build :user
      expect(new_user).to receive(:update_bepaid_bill)
      new_user.save
    end

    describe "on update" do
      context 'when tariff was changed ' do
        it 'invokes update_bepaid_bill' do
          user.tariff_id = tariff.id

          expect(user).to receive(:update_bepaid_bill)
          user.save
        end
      end

      context 'when tariff was not changed ' do
        it 'not invokes update_bepaid_bill' do
          expect(user).to_not receive(:update_bepaid_bill)
          user.save
        end
      end

      context 'when account_banned was changed ' do
        it 'invokes update_bepaid_bill' do
          user.account_banned = true

          expect(user).to receive(:update_bepaid_bill)
          user.save
        end
      end

      context 'when account_banned was not changed ' do
        it 'not invokes update_bepaid_bill' do
          expect(user).to_not receive(:update_bepaid_bill)
          user.save
        end
      end
    end
  end
end
