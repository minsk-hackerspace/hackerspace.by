require 'rails_helper'

describe NewsController, type: :controller do
  let(:news) { create :news }
  let(:admin_user) { create :admin_user }

  describe "GET 'index'" do
    it "returns http success" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      process :show, params: { id: news.id }
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
        process :show, params: { id: news.id }
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
        process :edit, params: { id: news.id }
        expect(response).to be_successful
      end
    end

    describe "POST 'create'" do
      it "returns http success create and redirect" do
        post :create, params: { news: { title: 'Super News', short_desc: 'short_desc', markup_type: 'html' } }
        expect(response).to redirect_to(news_path(News.last))
      end

      it "returns new page if not created" do
        post :create, params: { news: { title: 'Super News', short_desc: 'short_desc' } }
        expect(response).to render_template("new")
      end
    end

    describe "PUT 'update'" do
      it "returns http redirect" do
        process :update, params: { id: news.id, news: { title: 'Super News' } }
        expect(response).to redirect_to(news_path(news))
      end

      it "returns edit page" do
        process :update, params: { id: news.id, news: { show_on_homepage: true, show_on_homepage_till_date: nil, title: nil } }
        expect(response).to render_template("edit")
      end
    end

    describe "DELETE 'destroy'" do
      it "returns http success with redirect" do
        process :destroy, params: { id: news.id }
        expect(response).to redirect_to(news_index_path)
      end
    end
  end
end
