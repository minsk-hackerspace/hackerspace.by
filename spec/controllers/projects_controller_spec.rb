require 'rails_helper'

describe ProjectsController, type: :controller do
  let(:project) { create :project }
  let(:admin_user) { create :admin_user }

  describe "GET 'index'" do
    it "returns http success" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET 'show'" do
    it "returns http success" do
      process :show, params: { id: project.id }
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
        process :show, params: { id: project.id }
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
        process :edit, params: { id: project.id }
        expect(response).to be_successful
      end
    end

    describe "PUT 'update'" do
      it "returns http redirect" do
        process :update, params: { id: project.id, project: { name: 'Super project', short_desc: 'text' } }
        expect(response).to redirect_to(project_path(project))
      end

      it "returns edit page" do
        process :update, params: { id: project.id, project: { name: nil } }
        expect(response).to render_template("edit")
      end
    end

    describe "DELETE 'destroy'" do
      it "returns http success with redirect" do
        process :destroy, params: { id: project.id }
        expect(response).to redirect_to(projects_path)
      end
    end
  end
end
