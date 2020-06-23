require "rails_helper"

describe "Dashboard index", type: :feature do
  let(:duplicated_zip_code) { 33_302 }
  let(:partner) { create(:partner, :verified) }
  let(:user) { create(:user, partner: partner) }
  let!(:family_one) { create(:family, partner: partner, guardian_zip_code: duplicated_zip_code) }
  let!(:family_two) { create(:family, partner: partner, guardian_zip_code: duplicated_zip_code) }

  scenario "Partner sees only unique guardian zipcodes" do
    sign_in(user)
    visit(root_path)

    zip_code_values = find("[data-test='zip-codes']").text.split(", ").map(&:to_i)

    expect(zip_code_values).to eq([duplicated_zip_code])
  end
end
