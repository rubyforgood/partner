require "rails_helper"

RSpec.describe PartnerRequest, type: :model do
  it { is_expected.to have_many(:item_requests).dependent(:destroy) }

  it { is_expected.to validate_presence_of(:partner) }

  describe "a valid PartnerRequest" do
    it "requires a Partner" do
      expect(build_stubbed(:partner_request)).to be_valid
      expect(build_stubbed(:partner_request, partner: nil)).not_to be_valid
    end
  end

  describe "#formatted_item_requests_hash" do
    let(:partner_request) { create(:partner_request_with_item_requests, item_requests_count: 1) }
    it "builds the item_requests hash values for export json" do
      partner_request.reload
      item = partner_request.item_requests.first
      formatted_hash = [{ "item_id" => item["item_id"], "quantity" => item.quantity }]
      expect(partner_request.formatted_item_requests_hash(partner_request.item_requests)).to eql(formatted_hash)
    end
  end

  describe "a request without an item quantity" do
    let(:partner_request) { build(:partner_request) }
    let(:item_requests) { build(:item_request, name: "test", quantity: nil, partner_request: partner_request) }
    it "fails" do
      partner_request.item_requests << item_requests
      expect(partner_request.save).to be false
      expect(partner_request.errors.messages[:"item_requests.quantity"]).to include("can't be blank")
    end
  end
end
