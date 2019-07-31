require "rails_helper"

RSpec.describe "FamilyRequests", type: :request do
  describe "GET /new" do
    let(:partner) { create(:partner, :verified) }

    it 'renders the new template' do
      sign_in partner
      get "/family_requests/new"
      expect(response).to render_template(:new)
    end
  end

  describe 'POST /create' do
    let(:partner) { create(:partner, :verified, :with_family) }

    it 'creates a new family request' do
      requested_items = {"requested_items": [{"item_name": "foo", "item_id": 42, "count": 1}]}
      family_request = create(:family_request, partner: partner)
      stub_request(:post, diaperbank_routes.family_requests).with(
        body: { family_request: family_request }.to_json,
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Content-Type" => "application/json",
          # NOTE(chaserx): I don't know how to include diaperbank_routes here!s
          "Host" => diaperbank_routes.family_requests.host,
          "User-Agent" => "Ruby",
          "X-Api-Key" => ENV["DIAPERBANK_KEY"]
        }
      ).to_return(status: 200, body: requested_items.to_json, headers: {})

      sign_in partner
      post "/family_requests", params: {family_request: {child_ids: partner.children.ids}}
      expect(PartnerRequest.count).to eq(1)
    end
  end
end
