require 'rails_helper'

RSpec.describe Admin::BankTransactionsController, type: :controller do

  let(:user) { FactoryGirl.create(:admin_user) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
