class PublicSshKeysController < ApplicationController
  load_and_authorize_resource

  before_action :set_user, only: [:create, :destroy]

  def create
    @public_ssh_key = PublicSshKey.new(public_ssh_key_params)

    if @public_ssh_key.save
      redirect_to edit_user_path(@user)
    else
      redirect_to edit_user_path(@user),
        alert: "Ошибка сохранения SSH ключа: #{@public_ssh_key.errors.full_messages.join("\n")}"
    end
  end

  def destroy
    public_ssh_key = @user.public_ssh_keys.find_by(id: params[:id])
    public_ssh_key&.destroy
    redirect_to edit_user_path(@user)
  end

  private

    def public_ssh_key_params
      params.require(:public_ssh_key).permit(
        :body,
        :user_id
      )
    end

    def set_user
      @user = User.find(params[:user_id])
    end
end
