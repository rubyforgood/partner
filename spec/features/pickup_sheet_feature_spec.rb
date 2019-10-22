require "rails_helper"

describe "PickupSheet", type: :feature, include_shared: true, js: true do
  let(:partner) { create(:partner, :verified, id: 3) }
  let(:user) { create(:user, partner: partner) }
  let(:family) { create(:family, partner: partner) }
  let(:another_family) { create(:family, partner: partner) }
  let!(:children) do
    [
      create(:child, family: family),
      create(:child, family: family, item_needed_diaperid: 2),
      create(:child, family: family, item_needed_diaperid: 2),
      create(:child, family: another_family, item_needed_diaperid: 2),
      create(:child, family: another_family)
    ].sort_by(&:display_name)
  end
  let!(:child) { children.first }
  let!(:authorized_family_members) do
    [family, another_family].each_with_object({}) do |family, map|
      map[family.id] = Array.new(2).map do
        create(
          :authorized_family_member,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          family: family
        ).display_name
      end
    end
  end

  before do
    Flipper[:family_requests].enable(partner)
    sign_in(user)
  end

  scenario "partner can view a pickup sheet" do
    stub_successful_items_partner_request
    stub_successful_family_request
    visit partner_requests_path
    find_link("Create New Family Diaper Request").click
    find('input[type="submit"]').click
    expect(find("h3")).to have_text("Diaper Request History")
    partner_request_id = PartnerRequest.last.id
    visit family_request_pickup_sheets_path(family_request_id: partner_request_id)
    within "thead" do
      expect(find("tr th:nth-child(1)")).to have_text("Child's name")
      expect(find("tr th:nth-child(2)")).to have_text("Authorized Family Member")
      expect(find("tr th:nth-child(3)")).to have_text("Quantity Ordered")
      expect(find("tr th:nth-child(4)")).to have_text("Quantity Picked Up")
      expect(find("tr th:nth-child(5)")).to have_text("Item Ordered")
      expect(find("tr th:nth-child(6)")).to have_text("Item Picked Up")
      expect(find("tr th:nth-child(7)")).to have_text("Picked up")
    end
    within "tbody" do
      expect(find("tr:nth-child(2) td:nth-child(1)"))
        .to have_text(child.display_name)
      child.family.authorized_family_members.each do |family_member|
        expect(find("tr:nth-child(2) td:nth-child(2)"))
          .to have_text(family_member.display_name)
      end
      expect(find("tr:nth-child(2) td:nth-child(3)"))
        .to have_text(50)
    end
  end
end
