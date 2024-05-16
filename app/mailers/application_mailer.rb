class ApplicationMailer < ActionMailer::Base
  after_action :set_smtp_settings

  default from: Setting['mailer_from'] || 'info@hackerspace.by'
  layout 'mailer'

  private

  def set_smtp_settings
    return if Setting['mailer_user'].blank?

    mail.delivery_method.settings.merge!({
      user_name: Setting['mailer_user'],
      password: Setting['mailer_password']
    })
  end
end

