require 'rails_helper'

RSpec.describe ThanksController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Thank. As you add validations to Thank, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET #index" do
    it "returns a success response" do
      get :index, params: {}
      expect(response).to be_successful
    end

    it "assigns @thanks" do
      thank = Thank.create! valid_attributes
      get :index
      expect(assigns(:thanks)).to eq([thank])
    end

    it "renders the index template" do
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      thank = Thank.create! valid_attributes
      get :show, params: {id: thank.to_param}
      expect(response).to be_successful
    end
  end

  describe 'as admin user' do
    let(:admin_user) { create :admin_user }

    before do
      sign_in admin_user
    end

    describe "GET #new" do
      it "returns a success response" do
        get :new, params: {}

        expect(response).to be_successful
        expect(assigns(:thank)).to be_a_new(Thank)
      end
    end

    describe "GET #edit" do
      it "returns a success response" do
        thank = Thank.create! valid_attributes
        get :edit, params: {id: thank.to_param}
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      context "with valid params" do
        xit "creates a new Thank" do
          expect {
            post :create, params: {thank: valid_attributes}
          }.to change(Thank, :count).by(1)
        end

        xit "redirects to the created thank" do
          post :create, params: {thank: valid_attributes}
          expect(response).to redirect_to(Thank.last)
        end
      end

      context "with invalid params" do
        xit "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: {thank: invalid_attributes}
          expect(response).to be_successful
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) {
          skip("Add a hash of attributes valid for your model")
        }

        xit "updates the requested thank" do
          thank = Thank.create! valid_attributes
          put :update, params: {id: thank.to_param, thank: new_attributes}
          thank.reload
          skip("Add assertions for updated state")
        end

        xit "redirects to the thank" do
          thank = Thank.create! valid_attributes
          put :update, params: {id: thank.to_param, thank: valid_attributes}
          expect(response).to redirect_to(thank)
        end
      end

      context "with invalid params" do
        xit "returns a success response (i.e. to display the 'edit' template)" do
          thank = Thank.create! valid_attributes
          put :update, params: {id: thank.to_param, thank: invalid_attributes}
          expect(response).to be_successful
        end
      end
    end

    describe "DELETE #destroy" do
      xit "destroys the requested thank" do
        thank = Thank.create! valid_attributes
        expect {
          delete :destroy, params: {id: thank.to_param}
        }.to change(Thank, :count).by(-1)
      end

      xit "redirects to the thanks list" do
        thank = Thank.create! valid_attributes
        delete :destroy, params: {id: thank.to_param}
        expect(response).to redirect_to(thanks_url)
      end
    end
  end
end
