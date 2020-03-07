class BramnikController < ApplicationController
  before_action :authenticate_token
  skip_authorization_check
  load_resource :user

  def index
    @users = User.all.map { |u| {id: u.id, paid_until: u.paid_until, nfc_keys: u.nfc_keys.pluck(:body)} }
    render json: @users
  end


  def authenticate_token
    authenticate_or_request_with_http_token { |request_token, _| ActiveSupport::SecurityUtils.secure_compare(request_token, Rails.application.secrets.bramnik_token) }
  end
end
