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
    if @hs_open_status != 'unknown'
      endpoint[:state][:open] = @hs_open_status == "opened" ? true : false
      endpoint[:state][:lastchange] = Event.order('updated_at DESC').first.updated_at.to_i
    end

    respond_to do |format|
      format.json { render json: endpoint }
    end
  end
end

