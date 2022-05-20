require 'rails_helper'

RSpec.describe BramnikController, type: :controller do
  describe "GET #index unauthorized" do
    it "returns http unauthorized" do 
      get :index
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET #index authorized" do
    it "returns http authorized" do 
      request.headers["Authorization"] = "abcdef"
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #find_user unauthorized" do
    it "returns http unauthorized" do 
      get :find_user

      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET #find_user for unknown user" do
    it "returns http not_found" do
      request.headers["Authorization"] = "abcdef"
      get :find_user, params: { auth_token: 'random_token' }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET #find_user for known user" do
    render_views
    it "returns user" do
      user = FactoryBot.create(:user)
      user.generate_tg_auth_token!

      request.headers["Authorization"] = "abcdef"
      get :find_user, params: { auth_token: user.tg_auth_token }, format: :json

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)['id']).to eq(user.id)
    end
  end

  describe "GET #members_statistics" do
    it "returns http unauthorized" do
      get :members_statistics

      expect(response).to have_http_status(:unauthorized)
    end

    it "returns statistics" do
      request.headers["Authorization"] = "abcdef"
      get :members_statistics

      # TODO: Check for real data (after removing of seeds usage in the tests)
      expect(response).to have_http_status(:success)
    end
  end


end
