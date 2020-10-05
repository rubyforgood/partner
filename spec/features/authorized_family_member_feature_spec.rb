require "rails_helper"

describe AuthorizedFamilyMember, type: :feature do
  let!(:partner) { create(:partner) }
  let!(:user)    { create(:user, partner: partner) }
  let!(:family)  { create(:family, partner: partner) }

  before do
    Flipper[:family_requests].enable(partner)
    sign_in(user)
    visit(family_path(family))
  end

  scenario "creates a new authorized family member" do
    click_link("Add An Authorized Member To This Family")
    fill_in("First Name", with: "John")
    fill_in("Last Name", with: "Smith")
    click_button

    expect(AuthorizedFamilyMember.count).to eq 1
  end
end
