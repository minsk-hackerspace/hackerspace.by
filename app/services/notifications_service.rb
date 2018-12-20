class NotificationsService
  def self.notify_debitors
    new.notify_debitors
  end

  attr_reader :debitors

  def initialize
    @debitors = User.with_debt
  end

  def notify_debitors
    debitors.each do |debitor|
      NotificationsMailer.with(user: debitor).notify_about_debt.deliver_now
    end
  end
end
