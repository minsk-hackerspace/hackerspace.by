class MainController < ApplicationController
  def index
  end

  def rules
  end

  def calendar
  end

  def contacts
  end

  def spaceapi
    endpoint = SpaceAPIEndpoint.new
    if @hs_open_status != Hspace::UNKNOWN
      endpoint[:state][:open] = @hs_open_status == Hspace::OPENED
      endpoint[:state][:lastchange] = Event.order(updated_at: :desc).first.updated_at.to_i
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Cache-Control'] = 'no-cache'

    respond_to do |format|
      format.json { render json: endpoint }
    end
  end
end

