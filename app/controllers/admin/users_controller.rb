# frozen_string_literal: true

module Admin
  class UsersController < AdminController
    # before_action :set_user, only: [:edit, :update]
    authorize_resource class: User

    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)
      @user.set_password if @user.password.blank?

      if @user.save
        UserMailer.welcome(@user, @user.password).deliver_later

        flash[:alert] = @user.errors.full_messages.join "\n"
        redirect_to users_path, notice: 'Пользователь создан успешно'
      else
        render :new
      end
    end

    private

    # def set_user
    #   @user = User.find(params[:id])
    # end

    def user_params
      params.fetch(:user, {}).permit(:email, :first_name, :last_name, :password, :tariff_id)
    end
  end
end
