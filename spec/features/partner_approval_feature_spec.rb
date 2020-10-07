require "rails_helper"

describe "Partner approval", type: :feature do
  scenario "Submit for approval button is present when partner requires recertification" do
    partner = create(:partner, partner_status: "recertification_required")
    user = create(:user, partner: partner)
    sign_in(user)
    visit partner_path(partner.id)

    stub_request(:post, "#{ENV["DIAPERBANK_ENDPOINT"]}/approvals/")
      .with(body: { partner: { diaper_partner_id: partner.id } })
      .to_return(status: 200)

    click_link("Submit for Approval")
    visit partner_path(partner.id)
    expect(page).to have_content("Submitted")
  end
end
