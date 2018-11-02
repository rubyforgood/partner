require "rails_helper"

RSpec.describe PartnerRequestsController, type: :controller do
  login_partner

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do
    it "creates a new partner_request" do
      expect do
        post :create, params: { partner_request: FactoryBot.attributes_for(:partner_request_with_items) }
      end.to change(PartnerRequest, :count).by(1)
    end
  end

  describe "GET #show" do
    it "returns http success" do
      @partner_request = create(:partner_request_with_items)
      get :show, params: { id: @partner_request.id }
      expect(response).to have_http_status(200)
    end
  end
end
