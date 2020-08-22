require "rails_helper"

describe FamilyRequestsController, type: :feature, include_shared: true, js: true do
  context "when partner status is approved" do
    let(:partner) { create(:partner, :verified, id: 3) }
    let(:user) { create(:user, partner: partner) }
    let(:family) { create(:family, partner: partner) }
    let(:other_family) { create(:family, guardian_last_name: "Joester", partner: partner) }
    let(:another_family) { create(:family, partner: partner) }
    let!(:children) do
      [
        create(:child, family: family),
        create(:child, family: family, item_needed_diaperid: 2),
        create(:child, family: family, item_needed_diaperid: 2),
        create(:child, family: another_family, item_needed_diaperid: 2),
        create(:child, family: another_family)
      ]
    end

    before do
      Flipper[:family_requests].enable(partner)
      sign_in(user)
      visit(root_path)
    end

    describe "for children with different items, from different families" do
      scenario "it creates family requests" do
        child_item_requests = ChildItemRequest.count
        item_requests = ItemRequest.count
        stub_successful_items_partner_request
        stub_successful_family_request
        visit partner_requests_path
        find_link("Create New Family Diaper Request").click
        find('input[type="submit"]').click
        expect(page).to have_text("Request History")
        expect(ChildItemRequest.count - children.count).to eq(child_item_requests)
        expect(ItemRequest.count - 2).to eq(item_requests)
        expect(PartnerRequest.last.for_families?).to eq(true)
      end

      scenario "user can see a list of children filtered by first_name" do
        create(:child, first_name: "Zeno", family: family)
        create(:child, first_name: "Arthur", family: family)

        stub_successful_items_partner_request
        stub_successful_family_request
        visit partner_requests_path
        find_link("Create New Family Diaper Request").click
        fill_in "Search By Child Name", with: "Arthur"
        expect(page).to have_text("Arthur")
        expect(page).to_not have_text("Zeno")
      end

      scenario "user can see a list of children filtered by guardian name" do
        create(:child, first_name: "Zeno", family: family)
        create(:child, first_name: "Arthur", family: family)
        create(:child, first_name: "Louis", family: other_family)

        stub_successful_items_partner_request
        stub_successful_family_request
        visit partner_requests_path
        find_link("Create New Family Diaper Request").click
        fill_in "Search By Guardian Name", with: "Morales"
        expect(page).to have_css("table tbody tr", count: 7)
        expect(page).to have_text("Zeno")
        expect(page).to have_text("Arthur")
        expect(page).to_not have_text("Louis")
      end
    end

    describe "pickup sheet link" do
      scenario "it displays a link to a pickup sheet" do
        stub_successful_items_partner_request
        stub_successful_family_request
        visit partner_requests_path
        find_link("Create New Family Diaper Request").click
        find('input[type="submit"]').click
        expect(page).to have_text("Request History")
        within "tbody" do
          within find("tr:nth-child(1)") do
            within find("td:nth-child(3)") do
              click_link("Pickup Sheet")
            end
          end
        end
        expect(find("h1")).to have_text("Pickup Sheet")
      end
    end
  end

  context "when partner status in diaper base is 'deactivated'" do
    let(:partner) { create(:partner, :verified, id: 3, status_in_diaper_base: "deactivated") }
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
      ]
    end

    before do
      Flipper[:family_requests].enable(partner)
      sign_in(user)
      visit(root_path)
    end

    scenario "it don't create because partner status in diaper base is deactivated" do
      partner.update(status_in_diaper_base: "deactivated")
      visit partner_requests_path
      find_link("Create New Family Diaper Request").click
      expect(page).to have_text("Your account has been disabled, contact the organization via their email to reactivate")
      expect(current_path).to eq(partner_requests_path)
    end
  end
end
