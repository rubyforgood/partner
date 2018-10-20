require "rails_helper"

describe "Partners Api Requests" do
  #   describe 'GET "/api/v1/partners' do
  #     it "returns all partners" do
  #       partner = FactoryBot.create(:partner)

  #       get api_v1_partners_path

  #       expect(response).to have_http_status(:ok)

  #       results = JSON.parse(response.body)
  #       expect(results.size).to eq 1
  #       expect(results[0]["diaper_partner_id"]).to eq(partner.id)
  #     end
  #   end

  describe "GET /api/v1/partners/1" do
    let(:partner) { create(:partner) }

    it "returns json for the partner" do
      get api_v1_partner_path(partner)

      expect(response).to have_http_status(:ok)
      result = JSON.parse(response.body)
      expect(result["agency"]).to be_present
    end
  end
end
