class Admin::UsersController < AdminController
  before_action :set_user, only: [:edit, :update]
  authorize_resource class: User

  def index
    @users = User.order('last_sign_in_at desc nulls last').all
  end

  def edit
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:alert] = @user.errors.full_messages.join "\n"
      redirect_to admin_users_path, notice: 'Пользователь создан успешно'
    else
      render :new
    end
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'Профиль изменен'
      flash[:alert] = @user.errors.full_messages.join "\n"
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.fetch(:user, {}).permit(:next_month_payment_amount, :monthly_payment_amount, :current_debt, :email, :first_name, :last_name, :password)
  end
end
