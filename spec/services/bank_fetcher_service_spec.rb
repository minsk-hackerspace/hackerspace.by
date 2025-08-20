require 'rails_helper'

describe BankFetcherService do
  describe '#fetch_balance' do
    it 'returns nil' do
      expect(described_class.fetch_balance).to be_nil
    end
  end

  describe '#fetch_transactions' do
    before do
      allow(BankTransaction).to receive(:get_transactions).and_return([])
    end

    context "no transactions" do
      it 'returns nil' do
        expect(described_class.fetch_transactions).to eq []
      end
    end
  end
end
