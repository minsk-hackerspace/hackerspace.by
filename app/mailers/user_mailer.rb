class UserMailer < ApplicationMailer
  def welcome(user)
    @user = user
    @generated_password = user.password
    subject = 'Хакерспейс: ваш аккаунт создан'

    mail(to: @user.email, subject: subject)
  end
end
