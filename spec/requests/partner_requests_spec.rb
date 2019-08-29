require "rails_helper"

RSpec.describe "Partner Requests Controller", type: :request do
  context "when user authenticated" do
    let!(:partner) { create(:partner, :verified) }
    let!(:user) { create(:user, partner: partner) }

    before do
      sign_in user
    end

    describe "GET #new" do
      context "when partner status is approved" do
        it "returns http success" do
          # NOTE(chaserx): curious that this stub is required here and not
          #    elsewhere.
          # We get at @partner from the login_partner method above
          #
          id = partner.diaper_bank_id
          stub_request(:get, "https://diaper.test/partner_requests/#{id}")
            .with(
              headers: {
                "Accept" => "*/*",
               "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
               "Content-Type" => "application/json",
               "Host" => "diaper.test",
               "User-Agent" => "Ruby",
               "X-Api-Key" => "diaperkey"
              }
            )
            .to_return(status: 200, body: "{}", headers: {})

          get "/partner_requests/"
          expect(response).to have_http_status(200)
        end
      end

      context "when partner status is pending" do
        let!(:partner_pending) { create(:partner) }

        before do
          user.partner = partner_pending
        end

        it "returns http success" do
          get new_partner_request_path
          expect(response).to have_http_status(302)
        end
      end
    end

    describe "GET #show" do
      let!(:partner_request) { create(:partner_request) }

      it "returns http success" do
        get partner_requests_path(partner_request.id)
        expect(response).to have_http_status(200)
      end
    end

    describe "GET #index" do
      it "returns http success" do
        get partner_requests_path
        expect(response).to have_http_status(200)
      end
    end
  end

  context "when user not authenticated" do
    let!(:partner) { create(:partner) }

    describe "GET #new" do
      subject { get new_partner_request_path }

      it_behaves_like "user is not logged in"
    end

    describe "POST #create" do
      it "does not create a new partner_request" do
        expect do
          post partner_requests_path, params: { partner_request: attributes_for(:partner_request_with_item_requests) }
        end.to_not change(PartnerRequest, :count)
      end
    end

    describe "GET #index" do
      subject { get partner_requests_path }
      it_behaves_like "user is not logged in"
    end

    describe "GET #show" do
      subject { get partner_request_path(partner.id) }
      it_behaves_like "user is not logged in"
    end
  end
end
