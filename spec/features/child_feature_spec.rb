require "rails_helper"

describe Child, type: :feature, js: true do
  let(:partner) { create(:partner, id: 3) }

  before do
    sign_in(partner)
    visit(root_path)
  end

  scenario "User can see a list of children" do
    diaper_type = "Magic diaper"
    stub_request(:any, "#{ENV["DIAPERBANK_ENDPOINT"]}/partner_requests/#{partner.id}")
      .to_return(body: [{ id: 1, name: diaper_type }].to_json, status: 200)

    family = create(:family, partner: partner)
    children = [
      create(:child, family: family),
      create(:child, family: family)
    ].reverse
    click_link "Children"
    children.each.with_index do |child, index|
      within "tbody" do
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(1)"))
          .to have_text(child.first_name)
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(2)"))
          .to have_text(child.last_name)
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(3)"))
          .to have_text(child.date_of_birth)
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(5)"))
          .to have_text(child.family.guardian_display_name)
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(6)"))
          .to have_text(child.comments)
      end
    end
  end
end
