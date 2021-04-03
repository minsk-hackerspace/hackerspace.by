class BramnikController < ActionController::API

  def index
    if authenticate_token
      @users = User.active.map { |u| {id: u.id, name: "#{u.first_name} #{u.last_name}", paid_until: u.paid_until, access_allowed: u.access_allowed?, nfc_keys: u.nfc_keys.pluck(:body)} }
      render json: @users, status: :ok
    else
      render plain: "Authorization required\n", status: :unauthorized
    end
  end

  protected
  def authenticate_token
    ActiveSupport::SecurityUtils.secure_compare(request.headers['Authorization']&.split&.last || '', Rails.application.secrets.bramnik_token)
  end
end
