require "rails_helper"

RSpec.describe ChildrenController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/children").to route_to("children#index")
    end

    it "routes to #new" do
      expect(:get => "/children/new").to route_to("children#new")
    end

    it "routes to #show" do
      expect(:get => "/children/1").to route_to("children#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/children/1/edit").to route_to("children#edit", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/children").to route_to("children#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/children/1").to route_to("children#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/children/1").to route_to("children#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/children/1").to route_to("children#destroy", :id => "1")
    end
  end
end
