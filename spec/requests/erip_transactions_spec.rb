require 'rails_helper'

RSpec.describe "EripTransactions", type: :request do
  describe "GET /erip_transactions" do
    it "works! (now write some real specs)" do
      get erip_transactions_path
      expect(response).to have_http_status(200)
    end
  end
end