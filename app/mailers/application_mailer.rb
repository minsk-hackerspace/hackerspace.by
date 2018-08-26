class ApplicationMailer < ActionMailer::Base
  before_action :set_smtp_settings

  default from: Setting['mailer_from'] || 'info@hackerspace.by'
  layout 'mailer'

  private

  def set_smtp_settings
    smtp_settings.merge({
      user_name: Setting['mailer_from'],
      password: Setting['mailer_password']
    })
  end
end

