require 'rails_helper'

describe NotificationsService do
  describe '.notify_debitors' do
    let!(:user_without_payment) { create :user }
    let!(:user_with_outdated_payment) { create :user, :with_outdated_payment   }
    let!(:user_expires_in_2_days) { create :user, :expires_in_2_days   }
    let!(:user_with_valid_payment) { create :user, :with_valid_payment }
    let!(:suspended_user) { create :user, :suspended, :with_payment }

    let(:debitors) { described_class.new.debitors }
    let(:notified_emails) { ActionMailer::Base.deliveries.map(&:to).flatten }

    it 'sends notification email to expiring users only' do
      described_class.notify_expiring

      expect(notified_emails).not_to include(user_without_payment.email)
      expect(notified_emails).not_to include(user_with_valid_payment.email)
      expect(notified_emails).not_to include(suspended_user.email)
      expect(notified_emails).to include(user_expires_in_2_days.email)
    end
  end
end
