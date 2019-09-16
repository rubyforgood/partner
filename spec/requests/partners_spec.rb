require "rails_helper"

RSpec.describe "Partners", type: :request, include_shared: true do
  
  context "when authenticated" do
    login_user

    it "returns http success get#show" do
      get partner_path(@partner)
      
      expect(response).to have_http_status(200)
    end

    it "should redirect to partner get#approve" do
      stub_partner_requst
      get partner_approve_path(@partner)

      expect(response).to redirect_to(@partner)
    end

    it "does not allow access to partner post#index" do
      get partners_path

      expect(response).to have_http_status(:redirect)
    end

    describe "PATCH #update" do

      it "updates the partner" do
        expect { patch partner_path(@partner, params: { partner: { name: "updated name" } }) }.to change { @partner.reload.name }.to("updated name")
      end

      it "redirects to #show" do
        patch partner_path(@partner, params: { partner: { name: "updated name" } })

        expect(response).to redirect_to(@partner)
      end

      it "Show message of details" do
        patch partner_path(@partner, params: { partner: { name: "updated name" } })
        follow_redirect!

        expect(response.body).to include("Details were successfully updated.")
      end
    end

    it "displays the partner form get#edit" do
      get edit_partner_path(@partner)

      expect(response).to have_http_status(200)
    end

    describe "DELETE #destroy" do

      it "redirects the user" do
        delete partner_path(@partner.id)

        expect(response).to redirect_to(root_path)
      end

      it "does not delete partner" do
        delete partner_path(@partner.id)

        expect { subject }.to change(Partner, :count).by(0)
      end
      it "shows the message of not authorized" do
        delete partner_path(@partner.id)
        follow_redirect!
        follow_redirect!

        expect(response.body).to include("You are not authorized to perform this action.")
      end
    end
  end

  context "when not authenticated" do
    let!(:partner) { create(:partner) }

    describe "GET #show" do
      subject { get partner_path(partner) }

      it_behaves_like "user is not logged in"
    end

    describe "Get #approve" do
      subject { get partner_approve_path(partner) }

      it_behaves_like "user is not logged in"
    end

    describe "GET #index" do
      subject { get partners_path }

      it_behaves_like "user is not logged in"
    end

    describe "GET #edit" do
      subject { get edit_partner_path(partner) }

      it_behaves_like "user is not logged in"
    end

    describe "PATCH #update" do
      subject { patch partner_path(partner, params: { partner: { name: "updated name" } }) }

      it_behaves_like "user is not logged in"

      it "does not save the partner" do
        expect { subject }.not_to(change { partner.reload.name })
      end
    end

    describe "DELETE #destroy" do
      subject { delete partner_path(partner.id) }

      it_behaves_like "user is not logged in"

      it "does not delete partner" do
        expect { subject }.not_to change{ Partner.count }
      end

      it "returns a redirect" do
        subject
        expect(response).to have_http_status(:redirect)
      end
    end
  end

  def stub_partner_requst
    stub_request(:post, diaperbank_routes.partner_approvals).with(
      body: { partner: { diaper_partner_id: @partner.id } }.to_json,
      headers: {
        "Accept" => "*/*",
        "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
        "Content-Type" => "application/json",
        "Host" => diaperbank_routes.partner_approvals.host,
        "User-Agent" => "Ruby",
        "X-Api-Key" => ENV["DIAPERBANK_KEY"]
      }
    ).to_return(status: 200, body: "", headers: {})
  end
end
