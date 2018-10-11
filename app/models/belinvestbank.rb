require 'bib.rb'

class Belinvestbank
  def self.fetch_balance
    return nil if Setting['bib_login'].blank? or Setting['bib_password'].blank?
    bib = BelinvestbankApi::Bib.new(Setting['bib_baseURL'], Setting[:bib_loginBaseURL], Setting['bib_login'], Setting['bib_password'])
    balance_accounts = Setting['bib_balanceAccounts'].split(' ')
    accounts = nil
    begin
      bib.login
      accounts = bib.fetch_accounts.select { |key, val| balance_accounts.include?(key) }
    rescue
      Rails.logger.error "Balance cannot be fetched from bank"
      nil
    ensure
      bib.logout
    end
    balance = 0
    return nil unless accounts.kind_of? Hash
    accounts.each_value do |acc|
      balance += acc[:balance].to_d
    end
    Balance.create(state: balance) unless (!Balance.last.nil? and Balance.last.state == balance) or accounts.empty?
    balance
  end
end
