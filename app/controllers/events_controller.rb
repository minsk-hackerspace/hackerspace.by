#encoding: utf-8

class EventsController < ApplicationController
  before_action :set_log_event, only: [:update, :destroy, :show]
  skip_before_filter :verify_authenticity_token, :if => Proc.new { |c|
    c.request.format == 'application/json'
  }

  def index
    @log_events = LogEvent.order('timestamp DESC').all
    respond_to do |format|
      format.html
      format.json { render json: @log_events }
    end
  end

  def create
    @log_event = LogEvent.new
    @log_event.assign_attributes(event_params)
    @log_event.timestamp = Time.now if @log_event.timestamp.blank?

    respond_to do |format|
      if @log_event.save
        format.json { render json: @log_event, status: :created }
      else
        format.json { render json: @log_event.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    respond_to do |format|
      format.json { render json: @log_event }
    end
  end
 
  private

  def set_log_event
    @log_event = LogEvent.find(params[:id])
  end

  def event_params
    permitted_attrs = [:event_type, :value, :timestamp]
    params.require(:event).permit(permitted_attrs)
  end

end
