require "rails_helper"

describe "Static API Requests", type: :request do
  context "when getting the root url" do
    describe "GET #index" do
      it "returns http success" do
        get root_path
        expect(response).to have_http_status(200)
      end
    end
  end
  context "when url is correct and template is available" do
    describe "GET #page" do
      let(:name) { "index" }
      it "returns http success" do
        get static_page_path(name)
        expect(response).to have_http_status(200)
      end
    end
  end
  context "when url is correct and template isn't available" do
    describe "GET #page" do
      let(:name) { "index1" }
      it "returns http not_found" do
        get static_page_path(name)
        expect(response).to have_http_status(404)
      end
    end
  end
  context "when url characters are invalid" do
    describe "GET #page" do
      let(:name) { "index(" }
      it "returns http bad_request" do
        get static_page_path(name)
        expect(response).to have_http_status(400)
      end
    end
  end
end
