class EventsController < ApplicationController
  def index
    authenticate_user!
    @events = Event.limit(100).order(created_at: :desc)
  end

  def add
    begin
      device = Device.find_by(name: params[:name])

      if device.present? && device.valid_password?(params[:password])
        device.events.create!(event_type: params[:event_type], value: params[:value])

        render json: params, status: :ok
      else
        params[:status]= '401: Authorization required'
        render json: params, status: :unauthorized
      end
    rescue => e
      render json: "#{e.message}\n#{e.backtrace[0..4].join("\n")}", status: :unprocessable_entity
    end
  end
end
