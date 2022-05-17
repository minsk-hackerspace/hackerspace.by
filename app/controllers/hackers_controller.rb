class HackersController < ApplicationController
  load_and_authorize_resource :user, parent: false,
                              except: [:useful, :find_by_mac, :detected_at_hackerspace, :ssh_keys]

  def index
    @active_users = ActiveUsersQuery.perform(index_params)
    @non_active_users = User.where.not(id: @active_users.map(&:id))
    respond_to do |format|
      format.html
      format.csv { 
                   render csv: User.all, 
                   filename: 'hackers',
                   style: can?(:read, NfcKey) ? :with_nfc : :default 
                  }
      format.json
    end
  end

  def ssh_keys
    authorize! :ssh_keys, User

    @users = User.allowed.where.not(ssh_public_key: nil)
    ssh_keys = @users.map { |u| u.ssh_public_key }

    render plain: ssh_keys.join("\n")
  end

  def show
    @user.generate_tg_auth_token! if @user == current_user
  end

  def profile
    redirect_to current_user
  end

  def find_by_mac
    authorize! :find_by_mac, User
    set_hacker_by_mac

    if @hacker.nil?
      render json: {}, status: :not_found
    else
      render json: @hacker, status: :ok
    end
  end

  def detected_at_hackerspace
    authorize! :detected_at_hackerspace, User
    set_hacker_by_mac

    if @hacker.nil?
      render json: {}, status: :not_found
    else
      @hacker.update(last_seen_in_hackerspace: Time.now)
      render json: @hacker, status: :ok
    end
  end

  def add_mac
    if params[:mac].present? and params[:mac][/^([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})$/].present?
      @user.macs << Mac.create(address: params[:mac]&.downcase)
      redirect_to edit_user_path(@user)
    else
      redirect_to edit_user_path(@user), alert: 'Ошибка формата mac адреса'
    end
  end

  def remove_mac
    Mac.find(params[:mac_id])&.destroy
    redirect_to edit_user_path(@user)
  end

  def add_nfc
    @nfc_key = NfcKey.new(body: params[:nfc]&.downcase, user: @user)

    if @nfc_key.save
      redirect_to edit_user_path(@user)
    else
      redirect_to edit_user_path(@user),
        alert: "Ошибка сохранения NFC ключа: #{@nfc_key.errors.full_messages.join("\n")}"
    end
  end

  def remove_nfc
    key = @user.nfc_keys.find_by(body: params[:nfc]&.downcase)
    key&.destroy
    redirect_to edit_user_path(@user)
  end

  def edit
    redirect_to root_path, alert: 'Ошибка' unless @user == current_user or current_user.admin?
  end

  def useful
    authorize! :useful, User
    @page_content =
        if Rails.env.production?
          Net::HTTP.get(URI.parse('https://raw.githubusercontent.com/minsk-hackerspace/hackerspace.by/master/app/views/hackers/useful.md'))
        else
          File.read(Rails.root.join('app', 'views', 'hackers', 'useful.md'))
        end
  end

  def update
    @user.updating_by = current_user

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
      :guarantor2_id,
      :tariff_id
    )
  end

  def index_params
    params.slice(:order)
  end

  def set_hacker_by_mac
    @hacker = Mac.find_by(address: params[:mac]&.downcase).try(&:user)
  end
end
