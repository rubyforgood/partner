require "rails_helper"

RSpec.describe FamilyRequestsController, type: :request do
  let(:partner) { create(:partner, diaper_bank_id: 23) }
  let(:family) { create(:family, partner_id: partner.id) }
  let(:children) { FactoryBot.create_list(:child, 3, family: family) }
  let(:user) { create(:user, partner: partner) }

  before { sign_in(user) }

  describe 'GET #new' do
    subject { get new_family_request_path }

    it "does not allow deactivated partners" do
      partner.update!(status_in_diaper_base: :deactivated)

      expect(subject).to redirect_to(partner_requests_path)
    end

    it "does not allow partners not verified" do
      partner.update!(partner_status: :pending)

      expect(subject).to redirect_to(partner_requests_path)
    end
  end

  describe 'POST #create' do
    before do
      # Set one child as deactivated and the other as active but
      # without a item_needed_diaperid
      children[0].update(active: false)
      children[1].update(item_needed_diaperid: nil)
    end
    subject { post family_requests_path }

    it "does not allow deactivated partners" do
      partner.update!(status_in_diaper_base: :deactivated)

      expect(subject).to redirect_to(partner_requests_path)
    end

    it "does not allow partners not verified" do
      partner.update!(partner_status: :pending)

      expect(subject).to redirect_to(partner_requests_path)
    end

    it "submits the request with FamilyRequestService" do
      partner.update!(partner_status: :verified)

      family_request = double(FamilyRequest)
      expect(FamilyRequestPayloadService).to(
        receive(:execute)
          .with(children: [children.last], partner: partner)
          .and_return(family_request)
      )
      expect(FamilyRequestService).to receive(:execute).with(family_request)

      expect(subject).to redirect_to(partner_requests_path)
      expect(response.request.flash[:notice]).to eql "Requested items successfuly!"
    end
  end
end
