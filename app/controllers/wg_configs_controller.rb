class WgConfigsController < ApplicationController
  load_and_authorize_resource

  before_action :set_user, only: [:create, :destroy, :export]
  before_action :authenticate_token!, only: [:export_peers]

  def create
    @wgconfig = WgConfig.new(wg_config_params)

    if @wgconfig.save
      redirect_to edit_user_path(@user, anchor: 'wg-configs'), notice: "Конфигурация WireGuard создана успешно"
    else
      redirect_to edit_user_path(@user),
        alert: "Ошибка создания конфигурации WireGuard: #{@wgconfig.errors.full_messages.join("\n")}"
    end
  end

  def destroy
    wg = @user.wg_configs.find_by(id: params[:id])
    wg&.destroy
    redirect_to edit_user_path(@user, anchor: 'wg-configs')
  end

  def export
    wg = @user.wg_configs.find_by(id: params[:id])

    if wg
      send_data wg.to_s, filename: "wg-hackerspace-#{wg.name}.conf", type: "text/plain"
    else
      redirect_to user_path(@user), alert: "Конфигурация WireGuard не найдена"
    end
  end

  def export_peers
    wgs = WgConfig.order(:user_id).select { |wg| wg.user.active? }

    peers_config = wgs.map { |wg| wg.as_peer }.join("\n\n")

    render plain: peers_config
  end

  private

  def authenticate_token!
    token = request.headers['Authorization']&.split&.last
    if not ActiveSupport::SecurityUtils.secure_compare(token || '', Rails.application.secrets.wireguard_token) then
      render plain: "Authorization required\n", status: :unauthorized
    end
  end

  def wg_config_params
    params.require(:wg_config).permit(
      :name,
      :user_id
    )
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
