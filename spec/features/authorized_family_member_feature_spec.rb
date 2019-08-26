require "rails_helper"

describe AuthorizedFamilyMember, type: :feature do
  let!(:partner) { create(:partner, id: 3) }
  let!(:user)    { create(:user, partner: partner) }
  let!(:family)  { create(:family, partner: partner) }

  before do
    sign_in(user)
    visit(family_path(family))
  end

  it "creates a new authorized family member" do
    click_link("Add An Authorized Member To This Family")
    fill_in("First name", with: "John")
    fill_in("Last name", with: "Smith")
    click_button

    expect(AuthorizedFamilyMember.count).to eq 1
  end
end
