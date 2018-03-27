class HackersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :user, parent: false,
                              except: [:useful, :find_by_mac, :detected_at_hackerspace]
  load_and_authorize_resource :mac
  # before_action :set_hacker, only: [:show, :edit, :update, :add_mac, :remove_mac]

  def index
    @users = User.left_outer_joins(:payments).all
    @users_visible_for_all = (@users.where.not(last_sign_in_at: nil) | @users.where.not(payments: {id: nil})).select { |u| !u.account_suspended? and !u.account_banned? }.sort_by { |u| u.id }
    @suspended_banned_and_forgotten = (@users.uniq - @users_visible_for_all).sort_by { |u| u.id }
    respond_to do |format|
      format.html
      format.csv { render csv: @users_visible_for_all, filename: 'hackers' }
      format.json { render json: @users_visible_for_all}
    end
  end

  def show

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
    params.require(:user).permit(:email, :hacker_comment, :photo, :first_name, :last_name, :telegram_username, :alice_greeting, :account_suspended, :account_banned, :monthly_payment_amount)
  end

end
