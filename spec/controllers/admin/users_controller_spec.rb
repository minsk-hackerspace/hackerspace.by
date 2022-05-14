require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:user) { FactoryBot.create(:admin_user) }

  before do
    sign_in user
  end

  describe "GET #new" do
    it "returns http success" do
      process :new
      expect(response).to have_http_status(:success)
    end
  end
end
