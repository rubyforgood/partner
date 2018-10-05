require "rails_helper"

describe "Partners Api Requests" do
  describe 'GET "/api/v1/partners' do
    it "returns all partners" do
      partner = FactoryBot.create(:partner)

      get api_v1_partners_path

      expect(response).to have_http_status(:ok)

      results = JSON.parse(response.body)
      expect(results.size).to eq 1
      expect(results[0]["diaper_partner_id"]).to eq(partner.id)
    end
  end

  describe 'POST "/api/v1/partners' do
    it "creates a partner" do
      partner = FactoryBot.build(:partner)

      attrs = {
        diaper_bank_id: 1,
        diaper_partner_id: 1,
        email: partner.email
      }

      post api_v1_partners_path, params: attrs

      expect(response).to have_http_status(:ok)
      expect(Partner.count).to eq 1
    end
  end
end