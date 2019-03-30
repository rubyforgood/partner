require "rails_helper"

RSpec.describe FamiliesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/families").to route_to("families#index")
    end

    it "routes to #new" do
      expect(:get => "/families/new").to route_to("families#new")
    end

    it "routes to #show" do
      expect(:get => "/families/1").to route_to("families#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/families/1/edit").to route_to("families#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/families").to route_to("families#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/families/1").to route_to("families#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/families/1").to route_to("families#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/families/1").to route_to("families#destroy", :id => "1")
    end
  end
end
