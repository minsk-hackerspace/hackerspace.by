require 'rails_helper'

RSpec.describe Admin::BankTransactionsController, type: :controller do
  let(:bank_transaction) { create :bank_transaction }
  let(:user) { FactoryBot.create(:admin_user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "returns http success with filter params 'expenses'" do
      get :index, params: { filter: BankTransaction::EXPENSES }
      expect(response).to have_http_status(:success)
    end

    it "returns http success with filter params 'inpayments'" do
      get :index, params: { filter: BankTransaction::INPAYMENTS }
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #mass_update" do
    xit "returns http success" do
      request.env['HTTP_REFERER'] = root_path

      post :mass_update, params: { bank_transactions: { bank_transaction.id => { irregular: true, note: 'test' } } }

      expect(response).to redirect_to(root_path)
    end

    xit "returns http success when bank_transactions is nil" do
      request.env['HTTP_REFERER'] = root_path

      post :mass_update, params: { bank_transactions: {} }

      expect(flash[:notice]).to match(/Bank transactions update failed*/)
      expect(response).to redirect_to(root_path)
    end
  end
end
