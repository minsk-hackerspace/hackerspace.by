require 'rails_helper'

describe EventsController, type: :controller do
  let(:news) { create :news }
  let(:admin_user) { create :admin_user }

  describe "GET 'index'" do
    it "returns http success" do
      get :index
      expect(response).to redirect_to(new_user_session_url)
    end
  end

  context 'Logged in admin user' do
    before do
      sign_in admin_user
    end

    describe "GET 'index'" do
      it "returns http success" do
        get :index
        expect(response).to be_successful
      end
    end

    describe "GET 'add'" do

      it "returns 401 response without sent params" do
        get :add, params: { format: :json }

        expect(response.status).to eq(401)
      end

      context "with device" do
        let(:device) { create :device, name: 'bob' }

        it "returns 401 response without password parameter" do
          get :add, params: { name: device.name, format: :json }

          expect(response.status).to eq(401)
        end

        it "returns 200 status with valid params" do
          get :add, params: { name: device.name, password: device.password, format: :json }

          expect(response).to be_successful
        end
      end
    end
  end
end

