require 'rails_helper'

describe Admin::TariffsController, type: :controller do
  let(:tariff) { create :tariff }
  let(:admin_user) { create :admin_user }

  describe "GET 'index'" do
    it "returns http success" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      process :show, params: { id: tariff.id }
      expect(response).to be_successful
    end
  end

  describe "GET 'new'" do
    it "returns http success with redirect" do
      process :new
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'Logged in admin user' do
    before do
      sign_in admin_user
    end

    describe "GET 'show'" do
      it "returns http success" do
        process :show, params: { id: tariff.id }
        expect(response).to be_successful
      end
    end

    describe "GET 'new'" do
      it "returns http success" do
        process :new
        expect(response).to be_successful
      end
    end

    describe "GET 'edit'" do
      it "returns http success" do
        process :edit, params: { id: tariff.id }
        expect(response).to be_successful
      end
    end

    describe "POST 'create'" do
      it "returns http success and redirect" do
        expect {
          process :create,
            params: { tariff: { ref_name: 'ref_name', name: 'Super hacker tariff', monthly_price: 100, description: "description" }
            }
        }.to change { Tariff.count }.by(1)
      end
    end

    describe "PUT 'update'" do
      it "returns http success and redirect" do
        process :update, params: { id: tariff.id, tariff: { name: 'Super tariff', monthly_price: 100  } }

        expect(response.status).to redirect_to(admin_tariff_path(tariff))
      end

      it "returns edit page" do
        process :update, params: { id: tariff.id, tariff: { name: 'test', monthly_price: nil } }
        expect(response).to render_template("edit")
      end
    end

    describe "DELETE 'destroy'" do
      it "returns http success with redirect" do
        process :destroy, params: { id: tariff.id }
        expect(response).to redirect_to(admin_tariffs_path)
      end
    end
  end
end
