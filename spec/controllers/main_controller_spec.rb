require 'rails_helper'

describe MainController, type: :controller do
  let(:admin_user) { create :admin_user }
  let!(:event) { create :event }

  describe "GET 'index'" do
    it "returns http success" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET 'rules'" do
    it "returns http success" do
      get :rules
      expect(response).to be_successful
    end
  end

  describe "GET 'calendar'" do
    it "returns http success" do
      get :calendar
      expect(response).to be_successful
    end
  end

  describe "GET 'contacts'" do
    it "returns http success" do
      get :contacts
      expect(response).to be_successful
    end
  end

  describe "GET 'chart'" do
    it "returns http success" do
      get :chart
      expect(response).to redirect_to(new_user_session_url)
    end
  end

  describe "GET 'spaceapi'" do
    it "returns http success" do
      get :spaceapi, params: { format: :json }

      expect(response).to be_successful
    end
  end

  it "returns http success for exist device events" do
    get :spaceapi, params: { format: :json }

    expect(response).to be_successful
  end

  context 'Logged in admin user' do
    before do
      sign_in admin_user
    end

    describe "GET 'chart'" do
      let(:start) { (Time.now - 1.month).to_date }

      it "returns http success" do
        get :chart, params: { start: start }

        expect(response).to be_successful
      end

      it "returns http success for default chart range" do
        get :chart

        expect(response).to be_successful
      end

      it "returns http success for 'All' range" do
        get :chart, params: { range: 'All' }

        expect(response).to be_successful
      end
    end

    describe "GET 'spaceapi'" do
      it "returns http success" do
        get :spaceapi, params: { format: :json }

        expect(response).to be_successful
      end

      it "returns http success for exist device events" do
        get :spaceapi, params: { format: :json }

        expect(response).to be_successful
      end
    end
  end
end
