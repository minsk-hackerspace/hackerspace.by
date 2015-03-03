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

      format.json {
	device = Device.find_by(name: params[:device_name])
        if device.present?
          @events = Event.where(device: device, event_type: params[:event_type]).order(created_at: :asc)
          render json: @events, filename: 'events', status: :ok
        else
          params[:status]= '404: Device not found'
          render json: params, status: :unauthorized
        end
      }

    end
  end


  def fold
    begin
      authenticate_user!

      respond_to do |format|

        format.json {
	  device = Device.find_by(name: params[:device_name])

	  if device.present?

	    events = device.events.all.where(event_type: params[:event_type]).order(created_at: :asc)
	    new_items = [events.first]
	    prev_value = events.first.value

	    events.each do |event|
              if event.value != prev_value
	        new_items.append(event)
	        prev_value = event.value
	      end
	    end

	    render json: new_items, filename: 'events', status: :ok

	  else
	    params[:status]= '404: Device not found'
	    render json: params, status: :unauthorized
	  end

        }
      end

    rescue => e
      render json: "#{e.message}\n#{e.backtrace[0..4].join("\n")}", status: :unprocessable_entity
    end
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
