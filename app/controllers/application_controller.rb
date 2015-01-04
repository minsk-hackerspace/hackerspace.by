class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :check_if_hs_open

  def check_if_hs_open
    @event = LogEvent.where(event_type: "light").where("timestamp >= ?", DateTime.now.ago(1800)).order("timestamp DESC").first
    if @event.nil?
      @hs_open_status = "unknown"
    else
      if @event.value == "on"
        @hs_open_status = "opened"
      else
        @hs_open_status = "closed"
      end
    end
  end
end
