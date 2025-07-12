# frozen_string_literal: true

# == Schema Information
#
# Table name: bank_transactions
#
#  id              :integer          not null, primary key
#  plus            :float
#  minus           :float
#  unp             :string
#  their_account   :string
#  our_account     :string
#  document_number :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  irregular       :boolean          default(FALSE)
#  note            :string
#  contractor      :string
#  purpose         :string
#
# Indexes
#
#  index_bank_transactions_on_created_at  (created_at)
#  index_bank_transactions_on_updated_at  (updated_at)
#

require 'belinvestbank_api/bib'

class BankTransaction < ApplicationRecord
  EXPENSES = 'expenses'
  INPAYMENTS = 'inpayments'

  scope :expenses, -> { where('minus > 0') }
  scope :inpayments, -> { where('plus > 0') }

  def self.get_transactions(from = (Time.now - 45.days).strftime('%d.%m.%Y'), to = Time.now.strftime('%d.%m.%Y'))
    login = Setting['bib_login']
    password = Setting['bib_password']
    base_url = Setting['bib_baseURL']
    login_base_url = Setting['bib_loginBaseURL']

    bib = BelinvestbankApi::Bib.new(base_url, login_base_url, login, password)
    accounts = nil
    bib.login
    account_numbers = %w[BY50BLBB30150102386174001001 BY57BLBB31350102386174001001]
    begin
      accounts = bib.fetch_accounts
      account_numbers.each do |id|
        records = bib.fetch_log accounts[id][:id], from, to
        transactions = cleanup_input records
        transactions.each do |t|
          t = t.split(';', 10).map(&:strip)
          find_or_create_by our_account: id,
                            their_account: t[1].gsub(/=?"/, ''),
                            document_number: t[2].gsub(/=?"/, ''),
                            minus: t[3].gsub(',', '.').to_f,
                            plus: t[4].gsub(',', '.').to_f,
                            unp: t[5],
                            created_at: Time.zone.parse(t[6]),
                            contractor: t[7],
                            purpose: t[8]
        end
      end
    rescue StandardError => e
      Rails.logger.error 'Balance cannot be fetched'
      Rails.logger.error e.message
      nil
    ensure
      bib.logout
    end
  end

  def self.cleanup_input(records)
    records = records.split("\r\n")
    transactions_start = records.index records.select { |r| r.include?('Код банка'.force_encoding('utf-8')) }.first
    transactions_end = records.index records.select { |r| r.include?('Итого'.force_encoding('utf-8')) }.first
    records[transactions_start + 1..transactions_end - 1]
  end
end
