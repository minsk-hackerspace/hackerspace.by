require 'rails_helper'

describe MainController, type: :controller do

  describe "GET 'index'" do
    it "returns http success" do
      get :index
      expect(response).to be_success
    end
  end

  describe "GET 'rules'" do
    it "returns http success" do
      get :rules
      expect(response).to be_success
    end
  end

  describe "GET 'calendar'" do
    it "returns http success" do
      get :calendar
      expect(response).to be_success
    end
  end

  describe "GET 'contacts'" do
    it "returns http success" do
      get :contacts
      expect(response).to be_success
    end
  end
end
