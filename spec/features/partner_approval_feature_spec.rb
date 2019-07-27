require "rails_helper"

describe "Partner approval", type: :feature do
  scenario "Submit for approval button is present when partner requires recertification", js: true do
    partner = create(:partner, partner_status: "recertification_required")
    sign_in(partner)
    visit "/partners/#{partner.id}"

    stub_request(:post, "#{ENV["DIAPERBANK_ENDPOINT"]}/approvals/")
      .with(body: { partner: { diaper_partner_id: partner.id } })
      .to_return(status: 200)

    expect { click_link("Submit for Approval") }.to_not raise_error
    expect(partner.reload.partner_status).to eq("Submitted")
  end
end
