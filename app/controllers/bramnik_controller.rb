class BramnikController < ActionController::API
  before_action :authenticate_token!

  def index
      @users = User.all.map { |u| {id: u.id, name: "#{u.first_name} #{u.last_name}", paid_until: u.paid_until, access_allowed: u.access_allowed?, nfc_keys: u.nfc_keys.pluck(:body)} }
      render json: @users, status: :ok
  end

  # find user by various params
  def find_user
    token = params[:auth_token]

    @user = nil
    if token.present? then
      @user = User.find_by_auth_token(token)
    end

    unless @user.nil? then
      render
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
