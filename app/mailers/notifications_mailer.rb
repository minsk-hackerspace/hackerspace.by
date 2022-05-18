class NotificationsMailer < ApplicationMailer
  def notify_about_payment
    @transaction = params[:transaction]
    @user = @transaction.user
    return unless @user

    mail(to: @user.email, subject: 'Хакерспейс: Получена оплата')
  end

  def notify_about_debt
    @user = params[:user]
    email = Setting['test_notifications_email'].blank? ? @user.email : Setting['test_notifications_email']

    mail(to: email, subject: 'Хакерспейс: членские взносы')
  end

  def notify_about_suspend
    @user = params[:user]

    subject = 'Хакерспейс: ваш членский взнос истёк'
    mail(to: @user.email, subject: subject)
  end

  def notify_about_unsuspend
    @user = params[:user]

    subject = 'Хакерспейс: добро пожаловать обратно'
    mail(to: @user.email, subject: subject)
  end
end
