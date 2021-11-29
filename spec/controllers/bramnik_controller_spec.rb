require 'rails_helper'

RSpec.describe BramnikController, type: :controller do
  describe "GET #index unauthorized" do
    it "returns http unauthorized" do 
      get :index
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe "GET #index authorized" do
    it "returns http authorized" do 
      request.headers["Authorization"] = "abcdef"
      get :index
      expect(response).to have_http_status(:success)
    end
  end


end
