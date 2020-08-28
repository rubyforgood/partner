require "rails_helper"

describe "Partners API Requests", type: :request do
  describe "POST /api/v1/partners" do
    context "with valid API key" do
      context "when the body is empty" do
        it "responds with an error status code" do
          post api_v1_partners_path({}), headers: { 'X-Api-Key': ENV["DIAPER_KEY"] }

          expect(response).to have_http_status(:bad_request)
        end
      end

      context "when given valid parameters" do
        it "responds with an :ok status" do
          valid_partner_form_creation_request

          expect(response).to have_http_status(:ok)
        end

        it "creates a new `PartnerForm` record" do
          expect { valid_partner_form_creation_request }
            .to change { PartnerForm.count }
            .from(0)
            .to(1)
        end
      end
    end

    context "with invalid API key" do
      it "responds with forbidden" do
        expect do
          post api_v1_partner_forms_path(
            partner_form: {
              diaper_bank_id: 1,
              sections: %w(section1 section2 section3)
            }
          ), headers: { 'X-Api-Key': "INVALID" }
        end.to_not change { PartnerForm.count }

        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "Environment variable not set" do
    it "responds with forbidden" do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("DIAPER_KEY").and_return(nil)

      post api_v1_partner_forms_path(
        partner_form: {
          diaper_bank_id: 1,
          sections: %w(section1 section2 section3)
        }
      ), headers: { 'X-Api-Key': nil }

      expect(response).to have_http_status(:forbidden)
    end
  end

  def valid_partner_form_creation_request(
    diaper_bank_id: 1,
    sections: %w(section1 section2 section3)
  )
    post api_v1_partner_forms_path(
      partner_form: {
        diaper_bank_id: diaper_bank_id,
        sections: sections
      }
    ), headers: { 'X-Api-Key': ENV["DIAPER_KEY"] }
  end
end
