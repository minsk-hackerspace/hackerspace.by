class NotificationsService
  attr_reader :debitors

  def self.notify_expiring
    @users = User.fee_expires_in(7.days)
    @users.each do |debitor|
      NotificationsMailer.with(user: debitor).notify_about_debt.deliver_now
    end
  end

  def self.notify_telegram
    begin
      tg = TelegramNotifier.new
    rescue
      Rails.logger.warn "Telegram bot initialization failed"
      return
    end

    suspended = User.suspended_today

    m = ""

    @debitors = User.fee_expires_in(3.days)

    unless @debitors.empty?
      m += "Участники, у которых скоро закончится взнос:\n"

      m += @debitors.map{ |u| "#{u.full_name_with_id_tg} (оплачено по #{u.paid_until})" }.join("\n")
      m += "\n\n"
    else
      m += "У всех активных участников взносы оплачены.\n"
    end

    unless suspended.empty?
      m += "Участники, у которых закончился взнос:\n"
      m += suspended.map{ |u| u.full_name_with_id_tg }.join("\n")
      m += "Доступ в хакерспейс им закрыт до оплаты взноса (не менее, чем на две недели)."
    end

    tg.send_message_to_all(m)
  end

end
