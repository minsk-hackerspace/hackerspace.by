require "rails_helper"

RSpec.describe EripTransactionsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/erip_transactions").to route_to("erip_transactions#index")
    end

    it "routes to #new" do
      expect(:get => "/erip_transactions/new").to route_to("erip_transactions#new")
    end

    it "routes to #show" do
      expect(:get => "/erip_transactions/1").to route_to("erip_transactions#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/erip_transactions/1/edit").to route_to("erip_transactions#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/erip_transactions").to route_to("erip_transactions#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/erip_transactions/1").to route_to("erip_transactions#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/erip_transactions/1").to route_to("erip_transactions#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/erip_transactions/1").to route_to("erip_transactions#destroy", :id => "1")
    end

  end
end
