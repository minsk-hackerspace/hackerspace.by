require 'rails_helper'

describe NewsController, type: :controller do

  describe "GET 'index'" do
    it "returns http success" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET 'new'" do
    it "" do
      # get :new
      # expect(response).to be_success
    end
  end

  describe "GET 'show'" do
    it "" do
      # get :show, id: news.id
      # expect(response).to be_success
    end
  end

  describe "GET 'edit'" do
    it "" do
      # get :edit, id: news.id
      # expect(response).to be_success
    end
  end
end
