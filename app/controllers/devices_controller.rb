# frozen_string_literal: true

class DevicesController < ApplicationController
  load_and_authorize_resource
  def index
    @devices = Device.all
  end

  def show
    @device = Device.find(params[:id])
    @events = @device.events_folded
    respond_to do |format|
      format.html { render :show }
      format.csv { render csv: @events, filename: 'events' }
      format.json { render json: @events }
    end
  end
end
