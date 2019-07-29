require "rails_helper"

describe AuthorizedFamilyMember, type: :feature do
  let!(:partner) { create(:partner, id: 3) }
  let!(:user) { create(:user, partner: partner) }
  let!(:family) { create(:family, partner: partner) }

  before do
    sign_in(user)
    visit(families_path)
  end

  scenario "creates a new authorized family member" do
    expect(page).to have_text("Families")
    expect(page).to have_text("Morales")
    click_link("View Family")
    expect(page).to have_current_path(family_path(family))
    click_link("Add An Authorized Member To This Family")
    expect(page).to have_current_path(new_authorized_family_member_path, ignore_query: true)
    fill_in("First name", with: "John")
    fill_in("Last name", with: "Smith")
    click_button
    expect(AuthorizedFamilyMember.count).to eq 1
  end
end
