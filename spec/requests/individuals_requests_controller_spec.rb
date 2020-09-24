require "rails_helper"

RSpec.describe IndividualsRequestsController, type: :request do
  let(:partner) { create(:partner, partner_status: :verified) }
  let(:user) { create(:user, partner: partner) }
  let(:family_request_params) do
    {
      comments: "I need a lot of diapers",
      items_attributes: {
        "0" => { item_id: 12, person_count: 25 },
        "1231" => { item_id: 13, person_count: 45 }
      }
    }
  end

  before { sign_in(user) }
  subject { post(individuals_requests_path, params: { family_request: family_request_params }) }

  describe "POST /individuals_requests" do
    it "disallow unverified partners" do
      partner.update!(partner_status: :pending)

      expect(FamilyRequestService).to_not receive(:execute)

      expect(subject).to redirect_to(partner_requests_path)
    end

    it "creates the request using FamilyRequestService" do
      expect(FamilyRequestService).to(
        receive(:execute)
          .with(
            having_attributes(
              partner: partner,
              comments: "I need a lot of diapers",
              items: [
                have_attributes(item_id: "12", person_count: "25"),
                have_attributes(item_id: "13", person_count: "45"),
              ]
            )
          )
      )

      expect(subject).to redirect_to(partner_requests_path)
      expect(response.request.flash[:notice]).to eql "Requested items successfuly!"
    end

    it "renders the form again in case the request is somehow invalid" do
      expect(FamilyRequestService).to receive(:execute).and_raise ActiveModel::ValidationError.new(partner)

      expect(subject).to be 200
    end
  end
end
