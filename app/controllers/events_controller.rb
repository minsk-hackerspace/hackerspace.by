class EventsController < ApplicationController
  def index
    authenticate_user!

    respond_to do |format|
      format.html {
        @events = Event.limit(100).order(created_at: :desc)
        render :index
      }

      format.csv {
        @events = Event.order(created_at: :asc)
        render csv: @events, filename: 'events'
      }
    end
  end

  def add
    begin
      device = Device.find_by(name: params[:name])

      if device.present? && device.valid_password?(params[:password])
        repeated = device.check_if_repeated?(params[:event_type], params[:value])
        event = device.events.create(event_type: params[:event_type], value: params[:value], repeated: repeated)

        render json: event, status: :ok
      else
        params[:status]= '401: Authorization required'
        render json: params, status: :unauthorized
      end
    rescue => e
      render json: "#{e.message}\n#{e.backtrace[0..4].join("\n")}", status: :unprocessable_entity
    end
  end
end
