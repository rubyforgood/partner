require "rails_helper"

RSpec.describe FamilyRequest do
  let(:items_attributes) do
    {
      "0" => { item_id: 1, people_count: 10 },
      "1" => { item_id: 2, people_count: 12 },
      "21312" => { item_id: 3, people_count: 13 },
    }
  end

  it "can be initialized with a few items" do
    request = FamilyRequest.new({}, initial_items: 2)

    expect(request.items.size).to eq(2)
    expect(request.items.map(&:item_id)).to match_array [ nil, nil ]
    expect(request.items.map(&:people_count)).to match_array [ nil, nil ]
  end

  it "mass assigns items" do
    request = FamilyRequest.new(items_attributes: items_attributes)

    expect(request.items.size).to eq(3)
    expect(request.items.map(&:item_id)).to match_array [ 1, 2, 3 ]
    expect(request.items.map(&:people_count)).to match_array [ 10, 12, 13 ]
  end

  describe ".as_payload" do
    let(:partner) { build(:partner, diaper_bank_id: 1313, diaper_partner_id: 2525) }
    let(:request) { FamilyRequest.new({ items_attributes: items_attributes }, partner: partner) }
    subject { request.as_payload }

    it { is_expected.to include(organization_id: 1313) }
    it { is_expected.to include(partner_id: 2525) }

    describe "items" do
      subject { request.as_payload[:request_items] }

      it { is_expected.to include({ "item_id" => 1, "people_count" => 10 }) }
      it { is_expected.to include({ "item_id" => 2, "people_count" => 12 }) }
      it { is_expected.to include({ "item_id" => 3, "people_count" => 13 }) }
    end
  end
end
