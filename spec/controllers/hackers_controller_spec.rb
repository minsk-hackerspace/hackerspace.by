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

    describe "GET #ssh_keys" do
      let(:ssh_key_valid) { create :public_ssh_key }

      before do
        user.public_ssh_keys << ssh_key_valid
      end

      it "returns http success" do
        get :ssh_keys

        expect(response).to have_http_status(:success)
      end

      it "returns plain text respons" do
        get :ssh_keys

        expect(response.headers["Content-Type"]).to eq('text/plain; charset=utf-8')
      end

      it "contains SSH keys without of comments" do
        get :ssh_keys

        ssh_key_without_of_comment = ssh_key_valid.body.split(/\s+/, 3)[0..1].join(" ")
        expect(response.body).to_not include(ssh_key_valid.body)
        expect(response.body).to include(ssh_key_without_of_comment)
      end
    end
  end
end
