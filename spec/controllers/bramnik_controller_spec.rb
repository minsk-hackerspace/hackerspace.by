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
      get :find_user, params: { tg_username: 'random_nick' }

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "GET #find_user for known user" do
    it "returns user" do
      user = FactoryBot.create(:user)
      user.telegram_username = 'big_boss'
      user.save

      request.headers["Authorization"] = "abcdef"
      get :find_user, params: { tg_username: 'big_boss' }

      expect(response).to have_http_status(:success)
      expect(JSON.parse(response.body)).to eq({ "id" => user.id })
    end
  end



end
