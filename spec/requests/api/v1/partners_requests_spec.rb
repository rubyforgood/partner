require "rails_helper"

describe "Partners API Requests", type: :request do
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

  describe "PUT /api/v1/partners" do
    let(:headers) { { 'X-Api-Key': ENV["DIAPER_KEY"] } }

    context "when we set the partner to pending" do
      let(:partner) { create(:partner) }
      let(:params) { { partner: { diaper_partner_id: partner.diaper_bank_id, status: "pending" } } }

      it "returns OK" do
        valid_partner_update_request(params, headers)
        expect(response).to have_http_status(:ok)
      end

      it "sets the status to pending" do
        valid_partner_update_request(params, headers)
        expect(partner.reload.partner_status).to eq("pending")
      end
    end

    context "when we set the partner to recertification_required" do
      let(:partner) { create(:partner) }
      let(:params) { { partner: { diaper_partner_id: partner.diaper_bank_id, status: "recertification_required" } } }

      it "returns OK" do
        valid_partner_update_request(params, headers)
        expect(response).to have_http_status(:ok)
      end

      it "sets the status to Recertification Required" do
        valid_partner_update_request(params, headers)
        expect(partner.reload.partner_status).to eq("recertification_required")
      end

      it "shows recertification required status in the response body" do
        valid_partner_update_request(params, headers)
        expect(JSON.parse(response.body)["message"]).to eq("Partner status: recertification_required.")
      end

      it "emails a notification" do
        expect { valid_partner_update_request(params, headers) }.to change { ActionMailer::Base.deliveries.count }.by(1)
      end
    end

    context "when we set the partner to approved" do
      let(:partner) { create(:partner) }
      let(:params) { { partner: { diaper_partner_id: partner.diaper_bank_id, status: "approved" } } }

      it "returns OK" do
        valid_partner_update_request(params, headers)
        expect(response).to have_http_status(:ok)
      end

      it "sets the status to Verified" do
        valid_partner_update_request(params, headers)
        expect(partner.reload.partner_status).to eq("verified")
      end

      it "shows verified status in the response body" do
        valid_partner_update_request(params, headers)
        expect(JSON.parse(response.body)["message"]).to eq("Partner status: verified.")
      end
    end

    context "when we try to set the partner to blarg" do
      let(:partner) { create(:partner) }
      let(:params) { { partner: { diaper_partner_id: partner.diaper_bank_id, status: "blarg" } } }

      it "returns OK" do
        valid_partner_update_request(params, headers)
        expect(response).to have_http_status(:ok)
      end

      it "sets the status to pending" do
        valid_partner_update_request(params, headers)
        expect(partner.reload.partner_status).to eq("pending")
      end

      it "shows pending status in the response body" do
        valid_partner_update_request(params, headers)
        expect(JSON.parse(response.body)["message"]).to eq("Partner status: pending.")
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

  def valid_partner_update_request(params, headers = {})
    put "/api/v1/partners", params: params, headers: headers, as: :json
  end
end
