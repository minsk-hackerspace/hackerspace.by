class UserMailer < ApplicationMailer
  def welcome(user, password)
    @user = user
    @generated_password = password

    subject = 'Хакерспейс: ваш аккаунт создан'

    mail(to: @user.email, subject: subject)
  end
end
