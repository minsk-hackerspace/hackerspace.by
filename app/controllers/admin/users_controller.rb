class Admin::UsersController < AdminController
  before_action :set_user, only: [:edit, :update, :add_mac]
  authorize_resource class: User

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:alert] = @user.errors.full_messages.join "\n"
      redirect_to users_path, notice: 'Пользователь создан успешно'
    else
      render :new
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.fetch(:user, {}).permit(:email, :first_name, :last_name, :password, :monthly_payment_amount)
  end
end
