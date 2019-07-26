require "rails_helper"

describe AuthorizedFamilyMember, type: :feature do
  let!(:partner) { create(:partner, id: 3) }
  let!(:family) { create(:family, partner: partner)}

  before do
    sign_in(partner)
    visit(families_path)
  end

  scenario "vists families path" do
    expect(page).to have_text("Families")
    expect(page).to have_text("Morales")
    click_link("View Family")
    expect(page).to have_current_path(family_path(family))
    click_link("Add An Authorized Member To This Family")
    expect(page).to have_current_path(new_authorized_family_member_path, ignore_query: true)
  end
end
