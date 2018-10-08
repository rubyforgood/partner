require "rails_helper"

describe "Partner account registration" do
  it "User with invitation link can register an account" do
    Partner.invite!(email: "partner@email.com")

    open_email "partner@email.com"
    visit_in_email "Accept invitation"

    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    click_button "Create Account"

    expect(page).to have_content "Your account has been created successfully"
  end
end