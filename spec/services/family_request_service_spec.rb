require "rails_helper"

RSpec.describe FamilyRequestService do
  describe ".execute" do
    let(:success_response) do
      {
        "requested_items" => [
          { "item_name" => "Diaper XXL", "item_id" => "25", "count" => "4" },
          { "item_name" => "Diaper SM", "item_id" => "26", "count" => "8" }
        ]
      }
    end
    let(:child1) { create(:child) }
    let(:child2) { create(:child) }
    let(:child3) { create(:child) }
    let(:partner) { create(:partner) }
    let(:request) do
      FamilyRequest.new(
        items_attributes: {
          0 => { item_id: 25, person_count: 1, children: [child1] },
          1 => { item_id: 26, person_count: 2, children: [child2, child3] }
        },
        partner: partner
      )
    end

    it "submits the request to DiaperBank" do
      expect(DiaperBankClient).to(
        receive(:send_family_request)
          .with(hash_including(requested_items: [{ item_id: 25, person_count: 1 }, { item_id: 26, person_count: 2 }]))
          .and_return(success_response)
      )

      FamilyRequestService.execute(request)
    end

    it "creates the partner request record" do
      allow(DiaperBankClient).to receive(:send_family_request) { success_response }

      partner_request = FamilyRequestService.execute(request)

      expect(partner_request.partner).to eql partner
      expect(partner_request.item_requests.size).to eql 2
      expect(partner_request.item_requests.first.item_id).to eql 25
      expect(partner_request.item_requests.first.quantity).to eql "4"
    end

    it "saves the children associated to each item" do
      allow(DiaperBankClient).to receive(:send_family_request) { success_response }

      partner_request = FamilyRequestService.execute(request)

      expect(partner_request.partner).to eql partner
      expect(partner_request.item_requests.size).to eql 2
      expect(partner_request.item_requests.first.child_ids).to match_array [child1.id]
      expect(partner_request.item_requests.last.child_ids).to match_array [child2.id, child3.id]
    end

    it "validates the request prior to submitting it" do
      expect(request).to receive(:validate!).and_raise ActiveModel::ValidationError.new(request)
      expect(DiaperBankClient).to_not receive(:send_family_request)
      expect(PartnerRequest).to_not receive(:create!)

      expect { FamilyRequestService.execute(request) }.to raise_error ActiveModel::ValidationError
    end
  end
end
