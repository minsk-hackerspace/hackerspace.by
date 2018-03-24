require "rails_helper"

RSpec.describe ThanksController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/thanks").to route_to("thanks#index")
    end

    it "routes to #new" do
      expect(:get => "/thanks/new").to route_to("thanks#new")
    end

    it "routes to #show" do
      expect(:get => "/thanks/1").to route_to("thanks#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/thanks/1/edit").to route_to("thanks#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/thanks").to route_to("thanks#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/thanks/1").to route_to("thanks#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/thanks/1").to route_to("thanks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/thanks/1").to route_to("thanks#destroy", :id => "1")
    end

  end
end
