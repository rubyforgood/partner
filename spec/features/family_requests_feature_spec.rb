require "rails_helper"

describe FamilyRequestsController , type: :feature, js: true do
  let(:partner) { create(:partner, :verified, id: 3) }
  let(:family) { create(:family, partner: partner) }
  let(:another_family) { create(:family, partner: partner) }
  let!(:children) do
    [
      create(:child, family: family),
      create(:child, family: family, item_needed_diaperid: 2),
      create(:child, family: family, item_needed_diaperid: 2),
      create(:child, family: another_family,  item_needed_diaperid: 2),
      create(:child, family: another_family)
    ]
  end

  before do
    sign_in(partner)
    visit(root_path)
  end

  describe "for children with different items, from different families" do
    scenario "it creates family requests " do
      child_item_requests = ChildItemRequest.count
      item_requests = ItemRequest.count
      stub_successful_items_partner_request
      stub_successful_family_request
      visit partner_requests_path
      find_link('Create New Family Diaper Request').click
      find('input[type="submit"]').click
      expect(find('h3')).to have_text('Diaper Request History')
      expect(ChildItemRequest.count - children.count).to eq(child_item_requests)
      expect(ItemRequest.count - 2).to eq(item_requests)
    end
  end

  def stub_successful_items_partner_request
    stub_request(
      :any,
      "#{ENV["DIAPERBANK_ENDPOINT"]}/partner_requests/#{partner.id}"
    ).to_return(
      body: [
        {
          id: 1,
          name: "Magic diaper"
        },
        {
          id: 2,
          name: "Fantastic diaper"
        }
      ].to_json,
      status: 200
    )
  end

  def stub_successful_family_request
    diaper_bank_default_quantity = 50
    stub_request(
      :any,
      "#{ENV["DIAPERBANK_ENDPOINT"]}/family_requests/"
    ).to_return(
      body: {
        "partner_id" => partner.id,
        "organization_id" => partner.id,
        "requested_items": [
          {
            "item_name" => "Big Diaper",
            "item_id" => 1,
            "count" => 2 * diaper_bank_default_quantity
          },
          {
            "item_name" => "Small Diaper",
            "item_id" => 2,
            "count" => 3 * diaper_bank_default_quantity
          }
        ]
      }.to_json,
      status: 200)
  end
end
