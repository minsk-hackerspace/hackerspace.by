require 'rails_helper'

RSpec.describe Admin::UsersController, type: :controller do
  let(:admin) { FactoryBot.create(:admin_user) }
  let(:tariff) { create :tariff }

  context 'Logged in admin user' do
    before do
      sign_in admin
    end

    describe "GET #new" do
      it "returns http success" do
        process :new
        expect(response).to be_successful
      end
    end

    describe "GET 'show'" do
      xit "returns http success" do
        process :show, params: { id: admin.id }
        expect(response).to be_successful
      end
    end

    describe "GET 'edit'" do
      xit "returns http success" do
        process :edit, params: { id: admin.id }
        expect(response).to be_successful
      end
    end

    describe "POST 'create'" do
      it "returns http success create and redirect" do
        post :create, params: {
          user: { email: "example#{Time.now.to_i}@gmail.com", first_name: 'name', last_name: 'last', tariff_id: tariff.id }
        }
        expect(response).to redirect_to(users_path)
      end

      it "returns new page if not created" do
        post :create, params: { user: { name: 'test' } }
        expect(response).to render_template("new")
      end
    end
  end
end
