class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :check_if_hs_open

  def check_if_hs_open
    @event = Event.light.where('created_at >= ?', 30.minutes.ago).order(created_at: :desc).first

    @hs_open_status = if @event.nil?
                        'unknown'
                      else
                        @event.value == 'on' ? 'opened' : 'closed'
                      end
    # @hs_open_status = 'opened'
    # для отладки индикатора
  end
end
