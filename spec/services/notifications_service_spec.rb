require 'rails_helper'

describe NotificationsService do
  describe '.notify_debitors' do
    let!(:user_without_payment) { create :user }
    let!(:user_with_outdated_payment) { create :user, :with_outdated_payment   }
    let!(:user_with_valid_payment) { create :user, :with_valid_payment }
    let!(:suspended_user) { create :user, :suspended, :with_payment }

    let(:debitors) { described_class.new.debitors }
    let(:notified_emails) { ActionMailer::Base.deliveries.map(&:to).flatten }

    it 'notifies only debitors' do
      expect(debitors).to include(user_with_outdated_payment)
      expect(debitors).not_to include(user_without_payment)
      expect(debitors).not_to include(user_with_valid_payment)
    end

    it 'does not notify non-active users' do
      expect(debitors).not_to include(suspended_user)
    end

    it 'sends notification email to debitors' do
      described_class.notify_debitors

      expect(notified_emails).to include(user_with_outdated_payment.email)
    end
  end
end
