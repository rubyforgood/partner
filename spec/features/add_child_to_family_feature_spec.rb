require "rails_helper"

describe Child, type: :feature do
  let!(:partner) { create(:partner, id: 3) }
  let!(:user) { create(:user, partner: partner) }
  let!(:family) { create(:family, partner: partner) }

  before do
    sign_in(user)
    visit(families_path)
  end

  scenario "creates a child to a family member", js: true do
    diaper_type = "Magic diaper"
    stub_request(:any, "#{ENV["DIAPERBANK_ENDPOINT"]}/partner_requests/#{partner.id}")
      .to_return(body: [{ id: 1, name: diaper_type }].to_json, status: 200)
    expect(page).to have_text("Families")
    expect(page).to have_text("Morales")
    click_link("View Family")
    expect(page).to have_current_path(family_path(family))
    click_link("Add Child To This Family", match: :first)
    expect(page).to have_current_path(new_child_path, ignore_query: true)
    expect(page).to have_text("New Child")
    fill_in("First Name", with: "John")
    fill_in("Last Name", with: "Smith")
    expect { click_button }.to change { Child.count }.from(0).to(1)
  end
end
