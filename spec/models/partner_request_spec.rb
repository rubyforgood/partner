require "rails_helper"

RSpec.describe PartnerRequest, type: :model do
  describe "a valid PartnerRequest" do
    it "requires a Partner" do
      expect(build_stubbed(:partner_request)).to be_valid
      expect(build_stubbed(:partner_request, partner: nil)).not_to be_valid
    end
  end

  describe "#formatted_items_hash" do
    let(:partner_request) { create(:partner_request_with_items, items_count: 1) }
    it "builds the item hash values for export json" do
      item = partner_request.items.first
      formatted_hash = { "#{item.name}" => item.quantity }
      expect(partner_request.formatted_items_hash(partner_request.items)).to eql(formatted_hash)
    end
  end
end
