require "rails_helper"

describe Family, type: :feature, include_shared: true, js: true do
  let(:partner) { create(:partner, :verified, id: 3) }
  let(:user) { create(:user, partner: partner) }
  # let(:family) { create(:family, partner: partner) }
  # let(:other_family) { create(:family, guardian_last_name: "Joester", partner: partner) }

  before do
    Flipper[:family_requests].enable(partner)
    sign_in(user)
    visit(root_path)
  end

  scenario "User can see a list of families" do
    diaper_type = "Magic diaper"
    stub_request(:any, "#{ENV["DIAPERBANK_ENDPOINT"]}/partner_requests/#{partner.id}")
      .to_return(body: [{ id: 1, name: diaper_type }].to_json, status: 200)

    families = [
      create(:family, guardian_last_name: "Zeno", guardian_first_name: "Alex", agency_guardian_id: "Omen", partner: partner),
      create(:family, guardian_last_name: "Joestar", guardian_first_name: "Jonathan", agency_guardian_id: "Umbrela", partner: partner)
    ].reverse

    click_link "Families"
    families.each.with_index do |family, index|
      within "tbody" do
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(1)"))
          .to have_text(family.guardian_last_name)
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(2)"))
          .to have_text(family.guardian_first_name)
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(3)"))
          .to have_text(family.agency_guardian_id)
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(4)"))
          .to have_text(family.comments)
      end
    end
  end

  scenario "User can see a list of families filtered by name" do
    diaper_type = "Magic diaper"
    stub_request(:any, "#{ENV["DIAPERBANK_ENDPOINT"]}/partner_requests/#{partner.id}")
      .to_return(body: [{ id: 1, name: diaper_type }].to_json, status: 200)

    create(:family, guardian_last_name: "Zeno", guardian_first_name: "Alex", agency_guardian_id: "Omen", partner: partner)
    create(:family, guardian_last_name: "Joestar", guardian_first_name: "Jonathan", agency_guardian_id: "Umbrela", partner: partner)

    click_link "Families"
    fill_in "Search By Guardian Name", with: "Joestar"
    expect(page).to have_text("Joestar")
    expect(page).to_not have_text("Zeno")
  end

  scenario "User can see a list of families filtered by agency guardian" do
    diaper_type = "Magic diaper"
    stub_request(:any, "#{ENV["DIAPERBANK_ENDPOINT"]}/partner_requests/#{partner.id}")
      .to_return(body: [{ id: 1, name: diaper_type }].to_json, status: 200)

    create(:family, guardian_last_name: "Zeno", guardian_first_name: "Alex", agency_guardian_id: "Omen", partner: partner)
    create(:family, guardian_last_name: "Joestar", guardian_first_name: "Jonathan", agency_guardian_id: "Umbrela", partner: partner)

    click_link "Families"
    fill_in "Search By Agency Guardian", with: "Omen"
    expect(page).to have_css("table tbody tr", count: 1)
    expect(page).to have_text("Zeno")
    expect(page).to_not have_text("Joestar")
  end
end
