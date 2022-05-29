require 'rails_helper'

RSpec.describe PublicSshKeysController, type: :controller do
  let(:user) { create :user }
  let(:ssh_key) { create :public_ssh_key, user: user }
  let(:ssh_key_body) { build(:public_ssh_key).body }

  context 'Logged in user' do
    before do
      sign_in user
    end

    describe "DELETE 'destroy'" do
      before do
        ssh_key
      end

      it "returns http success with redirect" do
        process :destroy, params: { user_id: user.id, id: ssh_key.id }
        expect(response).to redirect_to(edit_user_path(user))
      end

      it "removes ssh key record" do
        expect {
          process :destroy, params: { user_id: user.id, id: ssh_key.id }
        }.to change { user.public_ssh_keys.count }.by(-1)
      end
    end

    describe "POST 'create'" do
      it "returns http success with redirect" do
        process :create, params: {user_id: user.id, public_ssh_key: { body: ssh_key_body, user_id: user.id }}
        expect(response).to redirect_to(edit_user_path(user))
      end

      it "creates ssh key for user" do
        expect {
          process :create, params: {user_id: user.id, public_ssh_key: { body: ssh_key_body, user_id: user.id }}
        }.to change { user.public_ssh_keys.count }.by(1)
      end
    end
  end
end
