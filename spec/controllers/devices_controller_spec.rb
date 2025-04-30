require 'rails_helper'

describe DevicesController, type: :controller do
  let(:device) { create :device }
  let(:user) { create :user }

  describe "GET 'index'" do
    it "returns http success" do
      get :index
      expect(response).to redirect_to(new_user_session_url)
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      get :show, params: { id: device.id }
      expect(response).to redirect_to(new_user_session_url)
    end
  end

  context 'Logged in admin user' do
    before do
      sign_in user
    end

    describe "GET 'index'" do
      it "returns http success" do
        get :index
        expect(response).to be_successful
      end
    end

    describe "GET 'show'" do
      it "returns http success" do
        get :show, params: { id: device.id }
        expect(response).to be_successful
      end
    end
  end
end