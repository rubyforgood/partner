require "rails_helper"

describe "Partners API Requests", type: :request do
  describe "POST /api/v1/partners" do
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
