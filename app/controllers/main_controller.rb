# frozen_string_literal: true

class MainController < ApplicationController
  #  before_action :authenticate_user!, only: [ :chart]
  authorize_resource class: false

  def index
    @news = News.homepage.where('show_on_homepage_till_date > ? ', Time.now).order(created_at: :desc).limit(2)
  end

  def rules; end

  def board; end

  def calendar
    @heatmap = Event.heatmap
  end

  def contacts; end

  def chart
    start_date = params[:start].try(:to_date) || Balance.first&.created_at&.to_date || Date.new(2017, 1, 1)
    end_date = params[:end].try(:to_date) || Time.now.to_date
    end_date += 1.day - 1.second

    @graph = Balance.graph(start_date, end_date)

    @expenses = BankTransaction.where(created_at: [start_date..end_date])
    @transactions = @expenses.where('minus > 0.0').order(created_at: :desc).page(params[:page])

    @expenses = if Rails.env.production?
                  [{ name: 'Поступления', data: @expenses.where(irregular: false).group_by_month(:created_at, format: '%m.%Y').sum(:plus) },
                   { name: 'Затраты',
                     data: @expenses.where(irregular: false).group_by_month(:created_at,
                                                                            format: '%m.%Y').sum(:minus) }]
                else
                  []
                end

    @paid_users = User.get_paid_users_graph(start_date, end_date)
  end

  def procedure; end

  def tariffs; end

  def howtopay; end

  def spaceapi
    endpoint = SpaceApiEndpoint.new
    if @hs_open_status != Hspace::UNKNOWN
      endpoint[:open] = @hs_open_status == Hspace::OPENED
      endpoint[:state] = {}
      endpoint[:state][:icon] =
        { open: helpers.image_url('/images/default.png'), closed: helpers.image_url('/images/default.png') }
      endpoint[:logo] = helpers.image_url('/images/default.png')
      endpoint[:state][:open] = @hs_open_status == Hspace::OPENED
      endpoint[:projects] = Project.published.map { |p| project_url(p) }
      endpoint[:state][:lastchange] = Event.order(updated_at: :desc).first.updated_at.to_i
      unless @hs_present_people.nil?
        endpoint[:sensors][:people_now_present][0][:value] = @hs_present_people.count
        endpoint[:sensors][:people_now_present][0][:names] = @hs_present_people if @hs_present_people.count.positive?
      end
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Cache-Control'] = 'no-cache'

    respond_to do |format|
      format.json { render json: endpoint }
    end
  end
end
