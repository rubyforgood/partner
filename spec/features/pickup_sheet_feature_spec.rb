require "rails_helper"

describe "PickupSheet", type: :feature do
  let(:partner) { create(:partner) }
  let(:family) { create(:family, partner: partner) }
  let(:another_family) { create(:family, partner: partner) }
  let(:children) do
    [
      create(:child, family: family),
      create(:child, family: another_family)
    ]
  end
  let!(:family_request) do
    create(:family_request, partner: partner, children: children)
  end
  let!(:authorized_family_members) do
    [family, another_family].map do |family|
      2.times.map do
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
    sign_in(partner)
  end

  xscenario "partner can view a list of pickup sheets", js: true do
  end

  scenario "partner can view a pickup sheet" do
    visit family_request_pickup_sheets_path(family_request_id: family_request.id)
    children.each.with_index do |child, index|
      within "tbody" do
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(1)"))
          .to have_text(child.display_name)
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(2)"))
          .to have_text(authorized_family_members[index].join(", "))
      end
    end
  end
end
