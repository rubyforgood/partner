require "rails_helper"

describe Partner, type: :feature do
  let!(:partner) { create(:partner) }
  let!(:user)    { create(:user, partner: partner) }

  before do
    sign_in user
  end

  describe "Partner approval" do
    let!(:partner_for_approval) { create(:partner, :recertification_required) }

    before do
      visit partners_path(partner_for_approval)
    end

    it "must have Submit for approval button when partner requires recertification" do
      stub_request(:post, "#{ENV["DIAPERBANK_ENDPOINT"]}/approvals/")
        .with(body: { partner: { diaper_partner_id: partner.id } })
        .to_return(status: 200)

      click_link("Submit for Approval")
      visit partners_path(partner)
      expect(page).to have_content("Submitted")
    end
  end

  describe "Partner edit" do
    before do
      visit "/partners/#{partner.id}/edit"
    end

    it "partner can select and provide an Other agency type", js: true do
      select "Other", from: "partner_agency_type"
      fill_in "partner_other_agency_type", with: Faker::Name.name
      click_button "Update Information"

      expect(page).to have_content "Details were successfully updated."
    end

    it "partner can fill out partner details" do
      fill_in "partner_name", with: Faker::Company.name
      select "Career technical training", from: "partner_agency_type"
      fill_in "partner_agency_mission", with: Faker::Lorem.paragraph
      fill_in "partner_address1", with: Faker::Address.street_address
      fill_in "partner_address2", with: Faker::Address.secondary_address
      fill_in "partner_city", with: Faker::Address.city
      fill_in "partner_state", with: Faker::Address.state_abbr
      fill_in "partner_zip_code", with: Faker::Address.zip_code
      fill_in "partner_website", with: Faker::Name.name
      fill_in "partner_facebook", with: Faker::Name.name
      fill_in "partner_founded", with: Faker::Number.number(4)
      check "partner_form_990"
      fill_in "partner_program_name", with: Faker::Name.name
      fill_in "partner_program_description", with: Faker::Lorem.paragraph
      fill_in "partner_program_age", with: Faker::Number.number(1)
      check "partner_case_management"
      check "partner_evidence_based"
      fill_in "partner_evidence_based_description", with: Faker::Lorem.paragraph
      fill_in "partner_program_client_improvement", with: Faker::Name.name
      fill_in "partner_diaper_use", with: Faker::Name.name
      fill_in "partner_other_diaper_use", with: Faker::Name.name
      check "partner_currently_provide_diapers"
      check "partner_turn_away_child_care"
      fill_in "partner_program_address1", with: Faker::Address.street_address
      fill_in "partner_program_address2", with: Faker::Address.secondary_address
      fill_in "partner_program_city", with: Faker::Address.city
      fill_in "partner_program_state", with: Faker::Address.state_abbr
      fill_in "partner_program_zip_code", with: Faker::Address.zip_code
      fill_in "partner_max_serve", with: Faker::Name.name
      fill_in "partner_incorporate_plan", with: Faker::Name.name
      check "partner_responsible_staff_position"
      check "partner_storage_space"
      fill_in "partner_describe_storage_space", with: Faker::Name.name
      check "partner_trusted_pickup"
      check "partner_income_requirement_desc"
      check "partner_serve_income_circumstances"
      check "partner_income_verification"
      check "partner_internal_db"
      check "partner_maac"
      fill_in "partner_population_black", with: Faker::Number.number(2)
      fill_in "partner_population_white", with: Faker::Number.number(2)
      fill_in "partner_population_hispanic", with: Faker::Number.number(2)
      fill_in "partner_population_asian", with: Faker::Number.number(2)
      fill_in "partner_population_american_indian", with: Faker::Number.number(2)
      fill_in "partner_population_island", with: Faker::Number.number(2)
      fill_in "partner_population_multi_racial", with: Faker::Number.number(2)
      fill_in "partner_population_other", with: Faker::Number.number(2)
      fill_in "partner_zips_served", with: Faker::Name.name
      fill_in "partner_at_fpl_or_below", with: Faker::Number.number(2)
      fill_in "partner_above_1_2_times_fpl", with: Faker::Number.number(2)
      fill_in "partner_greater_2_times_fpl", with: Faker::Number.number(2)
      fill_in "partner_poverty_unknown", with: Faker::Number.number(2)
      fill_in "partner_ages_served", with: Faker::Name.name
      fill_in "partner_executive_director_name", with: Faker::Name.name
      fill_in "partner_executive_director_phone", with: Faker::Number.number(10)
      fill_in "partner_executive_director_email", with: Faker::Name.name
      fill_in "partner_program_contact_name", with: Faker::Name.name
      fill_in "partner_program_contact_phone", with: Faker::Number.number(10)
      fill_in "partner_program_contact_mobile", with: Faker::Number.number(10)
      fill_in "partner_program_contact_email", with: Faker::Name.name
      fill_in "partner_pick_up_method", with: Faker::Name.name
      fill_in "partner_pick_up_name", with: Faker::Name.name
      fill_in "partner_pick_up_phone", with: Faker::Number.number(10)
      fill_in "partner_pick_up_email", with: Faker::Name.name
      fill_in "partner_distribution_times", with: Faker::Name.name
      fill_in "partner_new_client_times", with: Faker::Name.name
      fill_in "partner_more_docs_required", with: Faker::Name.name
      fill_in "partner_sources_of_funding", with: Faker::Name.name
      fill_in "partner_sources_of_diapers", with: Faker::Name.name
      fill_in "partner_diaper_budget", with: Faker::Name.name
      fill_in "partner_diaper_funding_source", with: Faker::Name.name

      click_button "Update Information"

      expect(page).to have_content("pending") &
                      have_content("Details were successfully updated.")
    end

    it "partner can attach documents" do
      attach_file("partner_proof_of_partner_status", "#{Rails.root}/spec/fixtures/test.pdf")
      attach_file("partner_proof_of_form_990", "#{Rails.root}/spec/fixtures/test.pdf")
      attach_file("partner_documents", "#{Rails.root}/spec/fixtures/test.pdf")

      click_button "Update Information"

      expect(page).to have_content "Details were successfully updated."
      expect(partner.proof_of_partner_status.attached?).to eq true
      expect(partner.proof_of_form_990.attached?).to eq true
      expect(partner.documents.attached?).to eq true
    end
  end

  describe "Partner account registration" do
    before do
      sign_out user
    end

    it "register an account with invitation link" do
      User.invite!(email: "partner@email.com", partner: partner)
      open_email "partner@email.com"
      visit_in_email "Accept invitation"
      fill_in "Password", with: "password123"
      fill_in "Password confirmation", with: "password123"
      click_button "Create Account"

      expect(page).to have_content "Your account has been created successfully"
    end
  end
end
