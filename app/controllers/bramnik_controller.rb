class BramnikController < ActionController::API
  before_action :authenticate_token!

  def index
      @users = User.all.map { |u| {id: u.id, name: "#{u.first_name} #{u.last_name}", paid_until: u.paid_until, access_allowed: u.access_allowed?, nfc_keys: u.nfc_keys.pluck(:body)} }
      render json: @users, status: :ok
  end

  # find user id by his telegram nick
  def find_user
    tg = params[:tg_username]

    user = nil
    if tg.present? then
      user = User.find_by(telegram_username: tg)
    end

    unless user.nil? then
      render json: { id: user.id }, status: :ok
    else
      render plain: "User not found", status: :not_found
    end
  end

  protected
  def authenticate_token!
    token = request.headers['Authorization']&.split&.last
    if not ActiveSupport::SecurityUtils.secure_compare(token || '', Rails.application.secrets.bramnik_token) then
      render plain: "Authorization required\n", status: :unauthorized
    end
  end
end
