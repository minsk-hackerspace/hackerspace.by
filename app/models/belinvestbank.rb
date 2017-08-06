require 'bib.rb'

class Belinvestbank
  def self.fetch_balance
    return nil if Setting['bib_login'].blank? or Setting['bib_password'].blank?
    bib = BelinvestbankApi::Bib.new(Setting['bib_baseURL'], Setting['bib_login'], Setting['bib_password'])
    accounts = nil
    begin
      bib.login
      accounts = bib.fetch_accounts
    rescue
      logger.error "Balance cannot be fetched from bank"
      nil
    ensure
      bib.logout
    end
    balance = 0
    accounts.each_value do |acc|
      balance += acc[:balance].to_f
    end
    balance
  end
end
