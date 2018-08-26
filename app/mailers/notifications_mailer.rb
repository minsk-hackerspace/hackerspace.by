class NotificationsMailer < ApplicationMailer
  def notify_about_payment
    @transaction = params[:transaction]
    @user = @transaction.user
    return unless @user

    mail(to: @user.email, subject: 'Хакерспейс: Получена оплата')
  end
end
