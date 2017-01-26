class Admin::UsersController < AdminController
  before_action :set_user, only: [:edit, :update]

  def index
    @users = User.all
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'Профиль изменен'
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
    params.fetch(:user, {}).permit(:next_month_payment_amount, :monthly_payment_amount, :current_debt)
  end
end
