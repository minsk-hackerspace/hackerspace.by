# frozen_string_literal: true

class EventsController < ApplicationController
  load_and_authorize_resource
  def index
    respond_to do |format|
      format.html do
        @events = Event.limit(100).order(created_at: :desc)
        render :index
      end

      format.csv do
        @events = Event.order(created_at: :asc)
        render csv: @events, filename: 'events'
      end
    end
  end

  def add
    device = Device.find_by(name: params[:name])

    if device.present? && device.valid_password?(params[:password])
      repeated = device.check_if_repeated?(params[:event_type], params[:value])
      event = device.events.create(event_type: params[:event_type], value: params[:value], repeated: repeated)

      render json: event, status: :ok
    else
      params[:status] = '401: Authorization required'
      render json: params, status: :unauthorized
    end
  rescue StandardError => e
    render json: "#{e.message}\n#{e.backtrace[0..4].join("\n")}", status: :unprocessable_entity
  end
end
