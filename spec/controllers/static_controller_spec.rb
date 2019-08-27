require "rails_helper"

xdescribe StaticController, type: :controller do
  context "when getting the root url" do
    describe "GET #index" do
      it "returns http success" do
        get :index
        expect(response).to have_http_status(200)
      end
    end
  end
  context "when url is correct and template is available" do
    describe "GET #page" do
      it "returns http success" do
        get :page, params: { name: "index" }
        expect(response).to have_http_status(200)
      end
    end
  end
  context "when url is correct and template isn't available" do
    describe "GET #page" do
      it "returns http not_found" do
        get :page, params: { name: "index1" }
        expect(response).to have_http_status(404)
      end
    end
  end
  context "when url characters are invalid" do
    describe "GET #page" do
      it "returns http bad_request" do
        get :page, params: { name: "index[" }
        expect(response).to have_http_status(400)
      end
    end
  end
end
