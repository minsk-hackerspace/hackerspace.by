class NotificationsService
  attr_reader :debitors

  def initialize
    @debitors = User.with_debt
  end

  def notify_debitors
    @debitors.each do |debitor|
      NotificationsMailer.with(user: debitor).notify_about_debt.deliver_now
    end
  end

  def notify_telegram
    begin
      tg = TelegramNotifier.new
    rescue
      Rails.logger.warn "Telegram bot initialization failed"
      return
    end

    suspended = User.suspended_today

    m = ""

    unless @debitors.empty?
      m += "Должники на сегодня:\n"

      m += @debitors.map{ |u| "#{u.full_name_with_id} (оплачено по #{u.paid_until})" }.join("\n")
      m += "\n\n"
    else
      m += "Должников на сегодня нет.\n"
    end

    unless suspended.empty?
      m += "Ушли в суспенд:\n"
      m += suspended.map{ |u| u.full_name_with_id }.join("\n")
    end

    tg.send_message_to_all(m)
  end

end
