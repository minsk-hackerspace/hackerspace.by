require "rails_helper"

RSpec.describe Admin::EripTransactionsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "admin/erip_transactions").to route_to("admin/erip_transactions#index")
    end

    it "routes to #new" do
      expect(:get => "admin/erip_transactions/new").to route_to("admin/erip_transactions#new")
    end

    it "routes to #show" do
      expect(:get => "admin/erip_transactions/1").to route_to("admin/erip_transactions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "admin/erip_transactions/1/edit").to route_to("admin/erip_transactions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "admin/erip_transactions").to route_to("admin/erip_transactions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "admin/erip_transactions/1").to route_to("admin/erip_transactions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "admin/erip_transactions/1").to route_to("admin/erip_transactions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "admin/erip_transactions/1").to route_to("admin/erip_transactions#destroy", :id => "1")
    end

  end
end
