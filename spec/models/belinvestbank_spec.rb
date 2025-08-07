# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Belinvestbank, type: :model do
  describe '.fetch_balance' do
    let(:bib_api) { instance_double(BelinvestbankApi::Bib) }
    let(:accounts) do
      {
        'BY50BLBB30150102386174001001' => { id: '123', balance: '1000.50' },
        'BY57BLBB31350102386174001001' => { id: '456', balance: '2000.75' }
      }
    end

    before do
      allow(Setting).to receive(:[]).with('bib_login').and_return('user')
      allow(Setting).to receive(:[]).with('bib_password').and_return('pass')
      allow(Setting).to receive(:[]).with('bib_baseURL').and_return('http://example.com')
      allow(Setting).to receive(:[]).with(:bib_loginBaseURL).and_return('http://login.example.com')
      allow(Setting).to receive(:[]).with('bib_balanceAccounts').and_return('BY50BLBB30150102386174001001 BY57BLBB31350102386174001001')
      allow(BelinvestbankApi::Bib).to receive(:new).and_return(bib_api)
      allow(bib_api).to receive(:login)
      allow(bib_api).to receive(:logout)
      allow(bib_api).to receive(:fetch_accounts).and_return(accounts)
      allow(Balance).to receive(:last).and_return(nil)
      allow(Balance).to receive(:create)
    end

    context 'when credentials are set' do
      it 'returns the correct balance' do
        expect(described_class.fetch_balance).to eq(3001.25)
      end

      it 'creates a new balance record if it changed' do
        allow(Balance).to receive(:last).and_return(instance_double(Balance, state: 1500.0))
        expect(Balance).to receive(:create).with(state: 3001.25)
        described_class.fetch_balance
      end

      it 'does not create a new balance record if it is the same' do
        allow(Balance).to receive(:last).and_return(instance_double(Balance, state: 3001.25))
        expect(Balance).not_to receive(:create)
        described_class.fetch_balance
      end

      it 'calls logout even when an error occurs' do
        allow(bib_api).to receive(:fetch_accounts).and_raise(StandardError)
        expect(Rails.logger).to receive(:error).with('Balance cannot be fetched from bank')
        described_class.fetch_balance
        expect(bib_api).to have_received(:logout)
      end
    end

    context 'when credentials are not set' do
      it 'returns nil if login is blank' do
        allow(Setting).to receive(:[]).with('bib_login').and_return('')
        expect(described_class.fetch_balance).to be_nil
      end

      it 'returns nil if password is blank' do
        allow(Setting).to receive(:[]).with('bib_password').and_return('')
        expect(described_class.fetch_balance).to be_nil
      end
    end
  end
end
