class BankFetcherService
  # Run by cron every hour
  def self.fetch_balance
    begin
      Rails.cache.write(
        "hs_balance",
        Belinvestbank.fetch_balance,
        expires_in: 3.hours
      ) unless Rails.env.development? or Rails.env.test?
    rescue => e
      Rails.logger.error(e.message)
      Rails.logger.error(e.backtrace)
      raise "Bank balance fetch error"
    end
  end

  # Run by cron every 4 hours
  def self.fetch_transactions
    begin
      BankTransaction.get_transactions
      Balance.where(state: 0).ids.each { |i|
        Balance.find(i).update(state: Balance.find(i-1).state)
      }
    rescue => e
      Rails.logger.error(e.message)
      Rails.logger.error(e.backtrace)
      raise "Bank transaction fetch error"
    end
  end
end
