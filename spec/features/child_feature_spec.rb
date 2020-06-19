require "rails_helper"

describe Child, type: :feature, include_shared: true, js: true do
  let(:partner) { create(:partner, :verified, id: 3) }
  let(:user) { create(:user, partner: partner) }
  let(:family) { create(:family, partner: partner) }
  let(:other_family) { create(:family, guardian_last_name: "Joester", partner: partner) }

  before do
    Flipper[:family_requests].enable(partner)
    sign_in(user)
    visit(root_path)
  end

  scenario "User can see a list of children" do
    diaper_type = "Magic diaper"
    stub_request(:any, "#{ENV["DIAPERBANK_ENDPOINT"]}/partner_requests/#{partner.id}")
      .to_return(body: [{ id: 1, name: diaper_type }].to_json, status: 200)

    children = [
      create(:child, last_name: "Zeno", family: family),
      create(:child, last_name: "Arthur", family: family)
    ].reverse

    click_link "Children"
    children.each.with_index do |child, index|
      within "tbody" do
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(1)"))
          .to have_text(child.last_name)
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(2)"))
          .to have_text(child.first_name)
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(3)"))
          .to have_text(child.date_of_birth)
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(5)"))
          .to have_text(child.family.guardian_display_name)
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(6)"))
          .to have_text(child.comments)
      end
    end
  end

  scenario "User can see a list of children filtered by first name" do
    diaper_type = "Magic diaper"
    stub_request(:any, "#{ENV["DIAPERBANK_ENDPOINT"]}/partner_requests/#{partner.id}")
      .to_return(body: [{ id: 1, name: diaper_type }].to_json, status: 200)

    create(:child, first_name: "Zeno", family: family)
    create(:child, first_name: "Arthur", family: family)

    click_link "Children"
    select "Arthur", from: "filters[from_children]"
    click_button "Filter"
    expect(page).to have_css("table tbody tr", count: 1)
  end

  scenario "User can see a list of children filtered by guardian name" do
    diaper_type = "Magic diaper"
    stub_request(:any, "#{ENV["DIAPERBANK_ENDPOINT"]}/partner_requests/#{partner.id}")
      .to_return(body: [{ id: 1, name: diaper_type }].to_json, status: 200)

    create(:child, first_name: "Zeno", family: family)
    create(:child, first_name: "Arthur", family: family)
    create(:child, first_name: "Louis", family: other_family)

    click_link "Children"
    select "Miles Morales", from: "filters[from_family]"
    click_button "Filter"
    expect(page).to have_css("table tbody tr", count: 2)
  end

  describe "Show View" do
    let!(:child) { create(:child, last_name: "Zeno", family: family) }

    scenario "User can see a list of requested items" do
      stub_successful_items_partner_request
      stub_successful_family_request
      visit partner_requests_path
      find_link("Create New Family Diaper Request").click
      find('input[type="submit"]').click
      expect(page).to have_text("Request History")
      visit child_path(child)
      within "tbody" do
        within find("tr:nth-child(1)") do
          expect(find("td:nth-child(1)")).to have_text(Time.zone.today.iso8601)
          expect(find("td:nth-child(2)")).to have_text("Magic diaper")
          expect(find("td:nth-child(3)")).to have_text("Not picked up")
          expect(find("td:nth-child(4)")).to have_text("100")
          expect(find("td:nth-child(5)")).to have_text("Not picked up")
        end
      end
    end
  end
end
