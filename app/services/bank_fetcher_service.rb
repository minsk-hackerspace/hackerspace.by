class BankFetcherService
  def self.fetch_balance
    Rails.cache.fetch "hs_balance", expires_in: 0.5.hours do
      begin
        Belinvestbank.fetch_balance unless Rails.env.development? or Rails.env.test?
      rescue => e
        Rails.logger.error(e.message)
        Rails.logger.error(e.backtrace)
        raise "Bank balance fetch error"
      end
    end
  end

  def self.fetch_transactions
    Rails.cache.fetch "bank_transactions", expires_in: 2.hours do
      begin
        BankTransaction.get_transactions
        Balance.where(state: 0).ids.each { |i| Balance.find(i).update(state: Balance.find(i-1).state) }
      rescue => e
        Rails.logger.error(e.message)
        Rails.logger.error(e.backtrace)
        raise "Bank transaction fetch error"
      end
    end
  end
end
