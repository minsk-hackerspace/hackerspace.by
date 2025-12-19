# == Schema Information
#
# Table name: payments
#
#  id                  :integer          not null, primary key
#  user_id             :integer
#  erip_transaction_id :integer
#  paid_at             :datetime         not null
#  amount              :decimal(, )      default(0.0), not null
#  start_date          :date
#  end_date            :date
#  payment_type        :string           not null
#  payment_form        :string           not null
#  description         :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  project_id          :integer
#
# Indexes
#
#  index_payments_on_erip_transaction_id  (erip_transaction_id)
#  index_payments_on_project_id           (project_id)
#  index_payments_on_user_id              (user_id)
#

require 'rails_helper'

RSpec.describe Payment, type: :model do

  let (:valid_payment_attrs) {
    {
      amount: 1.0,
      paid_at: DateTime.parse('2018-02-07T14:40:12.010Z'),
      start_date: Date.parse('2018-02-10'),
      end_date: Date.parse('2018-02-20'),
      payment_form: 'cash',
      payment_type: 'membership'
    }
  }

  it "should validate if (start_date - 1) is before or equal to end_date" do
    payment = Payment.new(valid_payment_attrs)
    expect(payment).to be_valid

    payment = Payment.new(valid_payment_attrs)
    payment.end_date = payment.start_date
    expect(payment).to be_valid

    payment = Payment.new(valid_payment_attrs)
    payment.end_date = payment.start_date - 1
    expect(payment).to be_valid

    payment = Payment.new(valid_payment_attrs)
    payment.end_date = payment.start_date - 2
    expect(payment).to_not be_valid
  end

  describe ".user_ids" do
    let!(:user) { create :user }
    let!(:user2) { create :user }

    before do
      create(:payment, user: user)
      create(:payment, user: user)
      create(:payment, user: user2)
      create(:payment)
    end

    it 'return uniq array of ids' do
      expect(Payment.user_ids).to eq([user.id, user2.id])
    end
  end

  describe "Save valid payment does set user as unsuspended" do
    let(:suspended_user) { create :user, :suspended }

    it 'does unsuspend user' do
      expect { create(:payment, user: suspended_user) }.to change { suspended_user.account_suspended }.from(true).to(false)
    end

    it 'does NOT unsuspend banned user' do
      suspended_user.account_banned = true
      expect { create(:payment, user: suspended_user) }.to_not change { suspended_user.account_suspended }
    end
  end

  describe '.set_paid_until_to_user' do
    let(:user) { create :user, paid_until: nil }
    let(:payment) { create(:payment, user: user) }

    context 'with user' do
      it 'sets payment end_date to user.paid_until' do
        payment = create(:payment, user: user)

        expect(payment.end_date).to eq(user.paid_until)
      end

      it 'sets payment end_date to user.paid_until instead of default nil value' do
        user = create :user, paid_until: nil
        payment = build(:payment, user: user)

        expect(user.paid_until).to eq(nil)
        expect { payment.save }.to change { user.paid_until }.from(nil).to(payment.end_date)
      end

      it 'sets latest payment end_date to user.paid_until' do
        payment2 = create(:payment, user: user, end_date: Time.now + 1.days )
        payment3 = create(:payment, user: user, end_date: Time.now + 300.days )

        expect(user.paid_until).to eq(payment3.end_date)
        expect(user.paid_until).to_not eq(payment2.end_date)
      end
    end

    context 'without user' do
      it 'does not set payment end_date to user.paid_until' do
        payment = build(:payment, user: nil)
        expect(payment).to_not receive(:set_paid_until_to_user)
        payment.save

        expect(payment.reload.user&.paid_until).to eq(nil)
      end
    end
  end

  describe ".set_user_as_unsuspended" do
    let(:user) { create :user, paid_until: nil }
    let(:payment_1) { create(:payment, user: user, start_date: Time.now - 50.days, end_date: Time.now - 30.days) }

    before do
      allow(Setting).to receive(:[]).with('tgToken').and_return('fake_token')
      allow(Setting).to receive(:[]).with('tgChatIds').and_return('12345 67890')
      allow(Setting).to receive(:[]).with('mailer_from').and_return('info@hackerspace.by')
      allow(Setting).to receive(:[]).with('mailer_user').and_return(nil)
    end

    it 'sets user as unsuspended' do
      user
      payment_1
      user.suspend!

      payment_2 = build(:payment, user: user)

      expect { payment_2.save }.to change { user.account_suspended }.from(true).to(false)
      expect(user.paid_until).to eq(payment_2.end_date)
    end

    it 'sets user as unsuspended with notification and correct paid_until date' do
      user
      payment_1
      user.suspend!

      payment_2 = build(:payment, user: user)

      expect(NotificationsMailer).to receive(:with).with(user: user)
      expect(TelegramNotifier).to receive(:new)

      payment_2.save

      expect(user.paid_until).to eq(payment_2.end_date)
      expect(user.paid_until).to_not eq(payment_1.end_date)
    end
  end
end
