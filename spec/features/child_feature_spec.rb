require "rails_helper"

describe Child, type: :feature, js: true do
  let!(:partner) { create(:partner, id: 3) }
  let!(:user)    { create(:user, partner: partner) }
  let!(:family)  { create(:family, partner: partner) }

  before do
    sign_in(user)

    stub_request(:any, "#{ENV["DIAPERBANK_ENDPOINT"]}/partner_requests/#{partner.id}")
      .to_return(body: [{ id: 1, name: "Magic diaper" }].to_json, status: 200)
  end

  describe "Show" do
    let!(:children) { create_list(:child, 2, family: family) }

    before do
      visit(root_path)
    end

    it "displays a list of children" do
      click_link "Children"
      children.each do |child|
        within "tbody" do
          expect(page).to have_text(child.first_name) &
                          have_text(child.last_name) &
                          have_text(child.date_of_birth) &
                          have_text(child.family.guardian_display_name) &
                          have_text(child.comments)
        end
      end
    end
  end

  describe "New" do
    before do
      sign_in(user)
      visit(family_path(family))
    end

    it "creates a child to a family member" do
      click_link("Add Child To This Family", match: :first)
      fill_in("First name", with: "John")
      fill_in("Last name", with: "Smith")
      click_button

      expect(Child.count).to eq 1
    end
  end
end
