require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create :user }

  describe '#invite' do
    specify do
      mailer = described_class.welcome(user)

      expect(mailer.to).to eq([user.email])
    end
  end
end
