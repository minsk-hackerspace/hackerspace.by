# frozen_string_literal: true

class BramnikController < ActionController::API
  before_action :authenticate_token!

  def index
    @users = User.all.map do |u|
      { id: u.id, name: u.full_name, paid_until: u.paid_until, access_allowed: u.access_allowed?,
        nfc_keys: u.nfc_keys.pluck(:body) }
    end
    render json: @users, status: :ok
  end

  # find user by various params
  def find_user
    @user = if params[:auth_token].present?
              User.find_by_auth_token(params[:auth_token])
            elsif params[:id].present?
              User.find_by(id: params[:id])
            end

    if @user.present?
      render
    else
      render plain: 'User not found', status: :not_found
    end
  end

  # Export the statistics about members
  def members_statistics
    members_count = User.count
    active_members = User.allowed

    tariff_stats = {}
    active_members.each do |user|
      t = user.tariff
      if tariff_stats[t.ref_name].nil?
        tariff_stats[t.ref_name] = {
          name: t.name,
          monthly_price: t.monthly_price,
          access_allowed: t.access_allowed,
          users: 0
        }
      end

      tariff_stats[t.ref_name][:users] += 1
    end

    render json: {
      members_count: members_count,
      active_members: active_members.count,
      tariff_stats: tariff_stats
    }
  end

  protected

  def authenticate_token!
    token = request.headers['Authorization']&.split&.last
    return if ActiveSupport::SecurityUtils.secure_compare(token || '', Rails.application.credentials.bramnik_token)

    render plain: "Authorization required\n", status: :unauthorized
  end
end
