class EventsController < ApplicationController
  def index
    authenticate_user!

    respond_to do |format|

      events = Event.all

      # filter by device name
      if params.has_key?(:device_name)
        device = Device.find_by(name: params[:device_name])
        if device.present?
          events = events.where(device: device)
        else
          params[:status]= '404: Device not found'
          render request.format.to_sym => params, status: :not_found
          return
        end
      end

      # filter by event_type
      if params.has_key?(:event_type)
        events = events.where(event_type: params[:event_type])
      end

      # order
      events = events.order(created_at: :asc)

      # fold (first events for sequences with same value)
      if params.has_key?(:device_name) && params.has_key?(:folded)
        new_items = [events.first]
        prev_value = events.first.value

        events.find_each(batch_size: 1024) do |event|
          if event.value != prev_value
            new_items.append(event)
            prev_value = event.value
          end
        end

        events = new_items
      end

      format.html {
	@events = events.last(100)
        render :index
      }

      format.any(:csv, :json) {
        render request.format.to_sym => events, filename: 'events', status: :ok
      }
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
