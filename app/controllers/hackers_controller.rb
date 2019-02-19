class HackersController < ApplicationController
#  before_action :authenticate_user!
  load_and_authorize_resource :user, parent: false,
                              except: [:useful, :find_by_mac, :detected_at_hackerspace]
  load_and_authorize_resource :mac
  # before_action :set_hacker, only: [:show, :edit, :update, :add_mac, :remove_mac]

  def index
    @active_users = ActiveUsersQuery.perform(index_params)
    @non_active_users = User.where.not(id: @active_users.map(&:id))
    respond_to do |format|
      format.html
      format.csv { render csv: User.all, filename: 'hackers' }
      format.json
    end
  end

  def find_by_mac
    @hacker = Mac.find_by(address: params[:mac]).try(&:user)
    if @hacker.nil?
      render json: {}, status: :not_found
    else
      render json: @hacker, status: :ok
    end
  end

  def detected_at_hackerspace
    @hacker = Mac.find_by(address: params[:mac]).try(&:user)
    if @hacker.nil?
      render json: {}, status: :not_found
    else
      @hacker.update(last_seen_in_hackerspace: Time.now)
      render json: @hacker, status: :ok
    end
  end

  def add_mac
    if params[:mac].present? and params[:mac][/^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/].present?
      @user.macs << Mac.create(address: params[:mac])
      redirect_to edit_user_path(@user)
    else
      redirect_to edit_user_path(@user), alert: 'Ошибка формата mac адреса'
    end
  end

  def remove_mac
    @user.macs.delete(Mac.find(params[:mac]))
    redirect_to edit_user_path(@user)
  end

  def edit
    redirect_to root_path, alert: 'Ошибка' unless @user == current_user or current_user.admin?
  end

  def useful
    @page_content =
        if Rails.env.production?
          Net::HTTP.get(URI.parse('https://raw.githubusercontent.com/minsk-hackerspace/hackerspace.by/master/app/views/hackers/useful.md'))
        else
          File.read(Rails.root.join('app', 'views', 'hackers', 'useful.md'))
        end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'Профиль изменен'
      flash[:alert] = @user.errors.full_messages.join "\n"
      redirect_to users_path
    else
      render :edit
    end
  end

  private

  def set_hacker
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :email,
      :hacker_comment,
      :photo,
      :first_name,
      :last_name,
      :telegram_username,
      :alice_greeting,
      :account_banned,
      :monthly_payment_amount,
      :github_username,
      :ssh_public_key,
      :is_learner,
      :project_id,
      :guarantor1_id,
      :guarantor2_id
    )
  end

  def index_params
    params.slice(:order)
  end
end
