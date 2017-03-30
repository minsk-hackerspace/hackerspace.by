class HackersController < ApplicationController
  before_action :authenticate_user!
  authorize_resource class: User
  before_action :set_hacker, only: [:show, :edit, :update]

  def index
    @users = User.order("coalesce(last_sign_in_at, '1970-01-01') desc").all
    respond_to do |format|
      format.html
      format.csv {render csv: @users, filename: 'hackers'}
    end
  end

  def show

  end

  def edit

  end

  def update
    if @user.update(user_params)
      flash[:notice] = 'Профиль изменен'
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
    params.require(:user).permit(:email, :hacker_comment, :photo)
  end
end
