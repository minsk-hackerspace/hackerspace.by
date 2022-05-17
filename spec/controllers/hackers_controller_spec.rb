require 'rails_helper'

RSpec.describe HackersController, type: :controller do
  let(:user) { FactoryBot.create(:user) }

  context 'Logged in user' do
    before do
      sign_in user
    end
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #index (CSV)" do
      it "returns http success" do
        get :index, format: :csv
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #edit" do
      it "returns http success" do
        process :edit, params: {id: user.id}
        expect(response).to have_http_status(:success)
      end
    end

    describe "GET #profile" do
      it "returns http success" do
        process :profile, params: {id: user.id}
        expect(response).to redirect_to(user_path(user))
      end
    end

    describe "GET #show" do
      it "returns http success" do
        process :show, params: {id: user.id }
        expect(response).to have_http_status(:success)
      end
    end

    describe "POST #add_mac" do
      it "returns http success" do
        process :add_mac, params: {id: user.id}

        expect(response).to redirect_to(edit_user_path(user))
      end

      it "returns http success" do
        expect {
            process :add_mac, params: {id: user.id, mac: '36:d8:b3:dd:f4:03'}
        }.to change { user.macs.count }.by(1)
      end
    end

    describe "DELETE #remove_mac" do
      let(:mac) { create :mac }

      before do
        user.macs << mac
      end  

      it 'returns 404 for wrong mac id' do
        expect { process :remove_mac, params: {id: user.id, mac_id: 123334} }.to raise_error(ActiveRecord::RecordNotFound)
      end

      it "returns redirect to edit user page" do
        process :remove_mac, params: {id: user.id, mac_id: mac.id}

        expect(response).to redirect_to(edit_user_path(user))
      end

      it "removes mac" do
        expect {
          process :remove_mac, params: {id: user.id, mac_id: mac.id}
        }.to change { user.macs.count }.by(-1)
      end
    end

    describe "GET #find_by_mac" do
      let(:mac) { create :mac }

      before do
        user.macs << mac
      end

      it 'returns 404 for wrong mac id' do
        process :find_by_mac, params: { mac: 132323334 }
        expect(response).to have_http_status(:not_found)
      end

      it "returns redirect to edit user page" do
        process :find_by_mac, params: { mac: mac.address }
        expect(response).to have_http_status(:success)
      end
    end
  end

  context 'Not logged in user' do
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET #index (CSV)" do
      it "returns http success" do
        get :index, format: :csv
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET #edit" do
      it "returns http success" do
        process :edit, params: {id: user.id}
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET #profile" do
      it "returns http success" do
        process :profile, params: {id: user.id}
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "GET #show" do
      it "returns http success" do
        process :show, params: {id: user.id }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    describe "DELETE #remove_mac" do
      let(:mac) { create :mac }

      it "returns redirect to edit user page" do
        process :remove_mac, params: {id: user.id, mac_id: mac.id}

        expect(response).to redirect_to(new_user_session_path)
      end
    end

    FAKE_SSH_KEY = "Test Fake SSH Key"
    describe "GET #ssh_keys" do
      before do
        user.ssh_public_key = FAKE_SSH_KEY
        user.save
      end

      it "returns http success" do
        get :ssh_keys

        expect(response).to have_http_status(:success)
        expect(Mime::Type.parse(response.content_type).first).to eq(Mime['text'])
      end

      it "contains SSH keys" do
        get :ssh_keys

        expect(response).to have_http_status(:success)
        expect(response.body).to include(FAKE_SSH_KEY)
      end
    end
  end
end
