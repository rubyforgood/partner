require 'rails_helper'

RSpec.describe "families/show", type: :view do
  before(:each) do
    @family = assign(:family, Family.create!(
      :guardian_first_name => "Guardian First Name",
      :guardian_last_name => "Guardian Last Name",
      :guardian_zip_code => "Guardian Zip Code",
      :guardian_country => "Guardian Country",
      :guardian_phone => "Guardian Phone",
      :agency_guardian_id => "Agency Guardian",
      :home_adult_count => 2,
      :home_child_count => 3,
      :home_young_child_count => 4,
      :sources_of_income => "",
      :guardian_employed => false,
      :guardian_employment_type => "",
      :guardian_monthly_pay => "9.99",
      :guardian_health_insurance => "",
      :comments => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Guardian First Name/)
    expect(rendered).to match(/Guardian Last Name/)
    expect(rendered).to match(/Guardian Zip Code/)
    expect(rendered).to match(/Guardian Country/)
    expect(rendered).to match(/Guardian Phone/)
    expect(rendered).to match(/Agency Guardian/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
    expect(rendered).to match(/4/)
    expect(rendered).to match(//)
    expect(rendered).to match(/false/)
    expect(rendered).to match(//)
    expect(rendered).to match(/9.99/)
    expect(rendered).to match(//)
    expect(rendered).to match(/MyText/)
  end
end
