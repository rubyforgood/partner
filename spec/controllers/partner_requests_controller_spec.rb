require "rails_helper"

describe PartnerRequestsController, type: :controller do
  context "when authenticated" do
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
          post :create, params: { partner_request: attributes_for(:partner_request_with_item_requests) }
        end.to change(PartnerRequest, :count).by(1)
      end
    end

    describe "GET #show" do
      it "returns http success" do
        @partner = create(:partner)
        sign_in @partner
        @partner_request = create(:partner_request_with_item_requests, partner: @partner)
        get :show, params: { id: @partner_request.id }
        expect(response).to have_http_status(200)
      end
    end
  end

  context "when not authenticated" do
    describe "GET #new" do
      subject { get :new }

      it_behaves_like "user is not logged in"
    end

    describe "POST #create" do
      it "does not create a new partner_request" do
        expect do
          post :create, params: { partner_request: attributes_for(:partner_request_with_item_requests) }
        end.to_not change(PartnerRequest, :count)
      end
    end

    describe "GET #show" do
      subject { get :show, params: { id: partner_request.id } }
      let(:partner) { create(:partner) }
      let(:partner_request) { create(:partner_request_with_item_requests, partner: partner) }

      it_behaves_like "user is not logged in"
    end

    describe "GET #index" do
      subject { get :index }
      it_behaves_like "user is not logged in"
    end
  end
end
