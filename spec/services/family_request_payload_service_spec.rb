require "rails_helper"

RSpec.describe FamilyRequestPayloadService do
  describe "diaper bank family request paylod" do
    let(:partner) { create(:partner) }
    let(:family) { create(:family, partner: partner) }
    let(:another_family) { create(:family, partner: partner) }
    let(:children) do
      [
        create(:child, family: family),
        create(:child, family: family, item_needed_diaperid: 2),
        create(:child, family: family, item_needed_diaperid: 2),
        create(:child, family: another_family, item_needed_diaperid: 2),
        create(:child, family: another_family)
      ]
    end

    let(:payload) do
      described_class.execute(children: children, partner: partner)
    end

    it "has an organization id" do
      expect(payload[:organization_id]).to eq(partner.diaper_bank_id)
    end

    it "has a partner id" do
      expect(payload[:partner_id]).to eq(partner.id)
    end

    it "has 2 requested items for diaper id 1" do
      item = payload[:requested_items].find do |request_item|
        request_item[:item_id] == 1
      end
      expect(item[:person_count]).to eq(2)
    end

    it "has 3 requested items for diaper id 2" do
      item = payload[:requested_items].find do |request_item|
        request_item[:item_id] == 2
      end
      expect(item[:person_count]).to eq(3)
    end
  end
end
