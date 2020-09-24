require "rails_helper"

RSpec.describe FamilyRequestsController, type: :request do
  let(:partner) { create(:partner, diaper_bank_id: 23) }
  let(:family) { create(:family, partner_id: partner.id) }
  let(:children) { FactoryBot.create_list(:child, 3, family: family) }
  let(:user) { create(:user, partner: partner) }

  before do
    sign_in(user)
  end

  describe 'POST #create' do
    before do
      # Set one child as deactivated and the other as active but
      # without a item_needed_diaperid
      children[0].update(active: false)
      children[1].update(item_needed_diaperid: nil)
    end

    it "should send a family request for only active children with a defined item needed" do
      expect(DiaperBankClient).to(
        receive(:send_family_request)
      )

      post family_requests_path
    end
  end
end
