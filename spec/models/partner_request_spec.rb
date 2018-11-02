require "rails_helper"

RSpec.describe PartnerRequest, type: :model do
  describe "a vali PartnerRequest" do
    it "requires a Partner" do
      expect(build_stubbed(:partner_request)).to be_valid
      expect(build_stubbed(:partner_request, partner: nil)).not_to be_valid
    end
  end
end
