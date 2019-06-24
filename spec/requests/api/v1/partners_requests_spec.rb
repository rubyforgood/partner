require "rails_helper"

describe "Partners Api Requests" do
  describe "GET /api/v1/partners/1" do
    let(:partner) { create(:partner) }

    it "returns json for the partner" do
      get api_v1_partner_path(partner)

      expect(response).to have_http_status(:ok)
      result = JSON.parse(response.body)
      expect(result["agency"]).to be_present
    end
  end

  describe "POST /api/v1/partners" do
    context "when the body is empty" do
      it "responds with an error status code" do
        post api_v1_partners_path({})

        expect(response).to have_http_status(:bad_request)
      end
    end

    context "when given valid parameters" do
      it "responds with an :ok status" do
        valid_partner_creation_request

        expect(response).to have_http_status(:ok)
      end

      it "creates a new `Partner` record" do
        expect { valid_partner_creation_request }
          .to change { Partner.count }
          .from(0)
          .to(1)
      end

      it "responds with the `id` and `email` of the new record" do
        valid_partner_creation_request(email: "new.partner@example.com")

        result = JSON.parse(response.body)

        expect(result).to have_key("id")
        expect(result).to have_key("email")
        expect(result["email"]).to eq("new.partner@example.com")
      end
    end
  end

  def valid_partner_creation_request(
    email: "test@example.com",
    diaper_bank_id: "diaper-bank-id",
    diaper_partner_id: "diaper-partner-id"
  )
    post api_v1_partners_path(
      partner: {
        email: email,
        diaper_bank_id: diaper_bank_id,
        diaper_partner_id: diaper_partner_id
      }
    )
  end
end
