require "rails_helper"

describe Child, type: :feature, js: true do
  let(:partner) { create(:partner) }

  before do
    sign_in(partner)
    visit(root_path)
  end

  scenario "User can see a list of children" do
    diaper_type = "Magic diaper"
    stub_request(:any, "#{ENV["DIAPERBANK_PARTNER_REQUEST_URL"]}/#{partner.id}")
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
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(4)"))
          .to have_text(child.gender)
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(5)"))
          .to have_text(child.child_lives_with)
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(6)"))
          .to have_text(child.race)

        expect(find("tr:nth-child(#{index + 1}) td:nth-child(8)"))
          .to have_text(child.health_insurance)
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(9)"))
          .to have_text(diaper_type)
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(10)"))
          .to have_text(child.comments)
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(11)"))
          .to have_text("Show")
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(12)"))
          .to have_text("Edit")
        expect(find("tr:nth-child(#{index + 1}) td:nth-child(13)"))
          .to have_text("Destroy")
      end
    end
  end
end
