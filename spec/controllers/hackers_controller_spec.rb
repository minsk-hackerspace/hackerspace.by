require 'rails_helper'

RSpec.describe HackersController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  before do
    sign_in user
  end
  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #edit" do
    it "returns http success" do
      process :edit, params: {id: user.id}
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      process :show, params: {id: user.id }
      expect(response).to have_http_status(:success)
    end
  end

end
