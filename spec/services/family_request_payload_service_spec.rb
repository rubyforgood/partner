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

    let(:request) do
      FamilyRequestPayloadService.execute(children: children, partner: partner)
    end

    it "has an organization id" do
      expect(request.partner).to eq(partner)
    end

    it "has 2 requested items for diaper id 1" do
      item = request.items.find do |request_item|
        request_item.item_id == 1
      end
      expect(item.person_count).to eq(2)
    end

    it "has 3 requested items for diaper id 2" do
      item = request.items.find do |request_item|
        request_item.item_id == 2
      end
      expect(item.person_count).to eq(3)
    end
  end
end
