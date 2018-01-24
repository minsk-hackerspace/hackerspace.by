require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:user) { FactoryGirl.create(:admin_user) }

  before do
    sign_in user
  end
  
  describe "PUT #update" do
    it "returns redirect" do
      process :update, method: :put, params: {id: user.id, user: {}}
      expect(response).to redirect_to admin_users_path
    end

    it "returns http success"
  end

end
