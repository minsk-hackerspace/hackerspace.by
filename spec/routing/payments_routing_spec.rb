require "rails_helper"

RSpec.describe Admin::PaymentsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "admin/payments").to route_to("admin/payments#index")
    end

    it "routes to #new" do
      expect(:get => "admin/payments/new").to route_to("admin/payments#new")
    end

    it "routes to #show" do
      expect(:get => "admin/payments/1").to route_to("admin/payments#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "admin/payments/1/edit").to route_to("admin/payments#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "admin/payments").to route_to("admin/payments#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "admin/payments/1").to route_to("admin/payments#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "admin/payments/1").to route_to("admin/payments#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "admin/payments/1").to route_to("admin/payments#destroy", :id => "1")
    end

  end
end
