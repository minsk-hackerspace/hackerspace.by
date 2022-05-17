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
    let!(:user) { create :user}
    let!(:user2) { create :user}

    before do
      create(:payment, user: user)
      create(:payment, user: user)
      create(:payment, user: user2)
      create(:payment)
    end

    xit 'return uniq array of ids' do
      expect(Payment.user_ids).to eq([user.id, user2.id])
    end
  end

  describe "Save valid payment does set user as unsuspended" do
    let(:suspended_user) { create :user, :suspended }

    it 'does unsuspend user' do
      expect{create(:payment, user: suspended_user)}.to change{suspended_user.account_suspended}.from(true).to(false)
    end

    it 'does NOT unsuspend banned user' do
      suspended_user.account_banned = true
      expect{create(:payment, user: suspended_user)}.to_not change{suspended_user.account_suspended}
    end
  end
end
