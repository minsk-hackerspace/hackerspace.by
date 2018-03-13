class MainController < ApplicationController
  before_action :authenticate_user!, only: [ :chart]

  def index
    @news = News.homepage.where("show_on_homepage_till_date > ? ", Time.now).order(created_at: :desc).limit(2)
  end

  def rules
  end

  def board
  end

  def calendar
    @heatmap = Event.heatmap
  end

  def contacts
  end

  def chart
    ds = params[:start].try(:to_date)
    unless Balance.first.nil?
      ds = Balance.first.created_at.to_date 
    else
      ds = Date.new(1970, 1 ,1)
    end
    de = params[:end].try(:to_date) || Time.now.to_date

    @graph = Balance.graph(ds, de)
    @transactions = BankTransaction.where(created_at: [ds..de])
    @expenses = [{name: 'Поступления', data: @transactions.group_by_month(:created_at, format: '%m.%Y').sum(:plus)},
                 {name: 'Затраты', data: @transactions.group_by_month(:created_at, format: '%m.%Y').sum(:minus)}
    ]
    @paid_users = User.get_paid_users_graph(ds,de)
  end

  def procedure

  end

  def tariffs

  end

  def howtopay

  end

  def spaceapi
    endpoint = SpaceApiEndpoint.new
    if @hs_open_status != Hspace::UNKNOWN
      endpoint[:open] = @hs_open_status == Hspace::OPENED
      endpoint[:state] = {}
      endpoint[:state][:icon] = {open: helpers.image_url('default.png'), closed: helpers.image_url('default.png')}
      endpoint[:logo] = helpers.image_url('default.png')
      endpoint[:state][:open] = @hs_open_status == Hspace::OPENED
      endpoint[:projects] = Project.published.map {|p| project_url(p)}
      endpoint[:state][:lastchange] = Event.order(updated_at: :desc).first.updated_at.to_i
      unless @hs_present_people.nil?
        endpoint[:sensors][:people_now_present][0][:value] = @hs_present_people.count
        endpoint[:sensors][:people_now_present][0][:names] = @hs_present_people if @hs_present_people.count > 0
      end
    end

    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Cache-Control'] = 'no-cache'

    respond_to do |format|
      format.json {render json: endpoint}
    end
  end
end

