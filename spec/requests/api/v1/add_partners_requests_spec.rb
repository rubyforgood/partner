require "rails_helper"

describe "Partners API Requests", type: :request do
  describe "POST /api/v1/add_partners" do
    context "when given valid parameters" do
      it "creates a new user record" do
        expect { valid_add_partner_creation_request }
          .to change { User.count }
          .from(0)
          .to(1)
      end
      it "doesn't creates a new user if it exists" do
        FactoryBot.create(:user, email: "test@example.com")
        expect { valid_add_partner_creation_request }
          .to_not change { User.count }
      end
    end
  end

  def valid_add_partner_creation_request(
      email: "test@example.com",
      diaper_partner_id: "diaper-partner-id"
    )
    post api_v1_add_partners_path(
      partner: {
        email: email,
          diaper_partner_id: diaper_partner_id
      }
    )
  end
end
