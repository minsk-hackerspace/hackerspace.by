class NotificationsMailer < ApplicationMailer
  def notify_about_payment
    @transaction = params[:transaction]
    @user = @transaction.user
    return unless @user

    mail(to: @user.email, subject: 'Хакерспейс: Получена оплата')
  end

  def notify_about_debt
    @user = params[:user]

    # mail(to: @user.email, subject: 'Хакерспейс: членские взносы')
    mail(to: "aliaksei.leanovich@gmail.com", subject: 'Хакерспейс: членские взносы')
  end
end
