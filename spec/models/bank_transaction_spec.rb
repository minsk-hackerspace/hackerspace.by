# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BankTransaction, type: :model do
  describe 'scopes' do
    let!(:expense) { create(:bank_transaction, minus: 100, plus: 0) }
    let!(:inpayment) { create(:bank_transaction, minus: 0, plus: 200) }

    it 'correctly selects expenses' do
      expect(BankTransaction.expenses.to_a).to eq([expense])
    end

    it 'correctly selects inpayments' do
      expect(BankTransaction.inpayments.to_a).to eq([inpayment])
    end
  end

  describe '.cleanup_input' do
    it 'cleans up the input records' do
      records = [
        'Some header line',
        'Another header line',
        'Код банка;Счет контрагента;Документ;Расход;Приход;УНП;Дата;Контрагент;Назначение платежа',
        'data1;data2;data3;data4;data5;data6;data7;data8;data9',
        'Итого: some footer data'
      ].join("\r\n")
      cleaned_records = described_class.cleanup_input(records)
      expect(cleaned_records).to eq(['data1;data2;data3;data4;data5;data6;data7;data8;data9'])
    end
  end

  describe '.get_transactions' do
    let(:bib_api) { instance_double(BelinvestbankApi::Bib) }
    let(:accounts) do
      {
        'BY50BLBB30150102386174001001' => { id: '123' },
        'BY57BLBB31350102386174001001' => { id: '456' }
      }
    end
    let(:records) do
      [
        'Код банка;Счет контрагента;Документ;Расход;Приход;УНП;Дата;Контрагент;Назначение платежа',
        ';BY00UNBS00000000000000000000;12345;0,00;100,50;190000000;28.02.2024;Иванов И.И.;Оплата по счету',
        'Итого: some footer data'
      ].join("\r\n")
    end

    before do
      allow(Setting).to receive(:[]).with('bib_login').and_return('user')
      allow(Setting).to receive(:[]).with('bib_password').and_return('pass')
      allow(Setting).to receive(:[]).with('bib_baseURL').and_return('http://example.com')
      allow(Setting).to receive(:[]).with('bib_loginBaseURL').and_return('http://login.example.com')
      allow(BelinvestbankApi::Bib).to receive(:new).and_return(bib_api)
      allow(bib_api).to receive(:login)
      allow(bib_api).to receive(:logout)
      allow(bib_api).to receive(:fetch_accounts).and_return(accounts)
      allow(bib_api).to receive(:fetch_log).and_return(records)
    end

    it 'fetches and creates transactions' do
      expect(described_class).to receive(:find_or_create_by).once.ordered.with(
        our_account: 'BY50BLBB30150102386174001001',
        their_account: 'BY00UNBS00000000000000000000',
        document_number: '12345',
        minus: 0.0,
        plus: 100.5,
        unp: '190000000',
        created_at: Time.zone.parse('28.02.2024'),
        contractor: 'Иванов И.И.',
        purpose: 'Оплата по счету'
      )
      expect(described_class).to receive(:find_or_create_by).once.ordered.with(
        our_account: 'BY57BLBB31350102386174001001',
        their_account: 'BY00UNBS00000000000000000000',
        document_number: '12345',
        minus: 0.0,
        plus: 100.5,
        unp: '190000000',
        created_at: Time.zone.parse('28.02.2024'),
        contractor: 'Иванов И.И.',
        purpose: 'Оплата по счету'
      )

      described_class.get_transactions
    end

    it 'calls logout even on error' do
      allow(bib_api).to receive(:fetch_accounts).and_raise(StandardError, 'API Error')
      expect(Rails.logger).to receive(:error).with('Balance cannot be fetched')
      expect(Rails.logger).to receive(:error).with('API Error')
      described_class.get_transactions

      expect(bib_api).to have_received(:logout)
    end
  end
end
