require 'rails_helper'

describe NotificationsService do
  describe '.notify_debitors' do
    let!(:user_without_payment) { create :user }
    let!(:user_with_outdated_payment) { create :user, :with_payment }
    let!(:user_with_valid_payment) { create :user, :with_valid_payment }

    it 'notifies only debitors' do
      expect(described_class.new.debitors).to eq([user_with_outdated_payment])
    end

    it 'sends notification email to each debitor' do
      described_class.notify_debitors

      expect(ActionMailer::Base.deliveries.count).to eq(1)
      expect(ActionMailer::Base.deliveries.first.to).to eq([user_with_outdated_payment.email])
    end
  end
end
