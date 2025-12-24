require 'rails_helper'

RSpec.describe HackersHelper, type: :helper do
  let(:hacker) { create :user }

  describe ".row_class" do
    context 'without payment' do
      let(:user) { create :user }

      it 'returns "warning"' do
        expect(helper.row_class(user)).to eq('warning')
      end
    end

    context 'hacker is inactive' do
      it 'returns nil with account suspended' do
        hacker.account_suspended = true
        hacker.account_banned = false
        expect(helper.row_class(hacker)).to eq(nil)
      end

      it 'returns nil with account banned' do
        hacker.account_banned = true
        hacker.account_suspended = false
        expect(helper.row_class(hacker)).to eq(nil)
      end
    end

    context 'with outdated payment' do
      let(:hacker_with_outdated_payment) { create :user, :with_outdated_payment }

      it 'returns "info" as learner' do
        hacker_with_outdated_payment.is_learner = true
        expect(helper.row_class(hacker_with_outdated_payment)).to eq('info')
      end

      it 'returns "danger"' do
        hacker_with_outdated_payment.is_learner = false

        expect(helper.row_class(hacker_with_outdated_payment)).to eq('danger')
      end
    end
  end
end
