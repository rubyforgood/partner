require 'rails_helper'

RSpec.describe "families/new", type: :view do
  before(:each) do
    assign(:family, Family.new(
      :guardian_first_name => "MyString",
      :guardian_last_name => "MyString",
      :guardian_zip_code => "MyString",
      :guardian_country => "MyString",
      :guardian_phone => "MyString",
      :agency_guardian_id => "MyString",
      :home_adult_count => 1,
      :home_child_count => 1,
      :home_young_child_count => 1,
      :sources_of_income => "",
      :guardian_employed => false,
      :guardian_employment_type => "",
      :guardian_monthly_pay => "9.99",
      :guardian_health_insurance => "",
      :comments => "MyText"
    ))
  end

  it "renders new family form" do
    render

    assert_select "form[action=?][method=?]", families_path, "post" do

      assert_select "input[name=?]", "family[guardian_first_name]"

      assert_select "input[name=?]", "family[guardian_last_name]"

      assert_select "input[name=?]", "family[guardian_zip_code]"

      assert_select "input[name=?]", "family[guardian_country]"

      assert_select "input[name=?]", "family[guardian_phone]"

      assert_select "input[name=?]", "family[agency_guardian_id]"

      assert_select "input[name=?]", "family[home_adult_count]"

      assert_select "input[name=?]", "family[home_child_count]"

      assert_select "input[name=?]", "family[home_young_child_count]"

      assert_select "input[name=?]", "family[sources_of_income]"

      assert_select "input[name=?]", "family[guardian_employed]"

      assert_select "input[name=?]", "family[guardian_employment_type]"

      assert_select "input[name=?]", "family[guardian_monthly_pay]"

      assert_select "input[name=?]", "family[guardian_health_insurance]"

      assert_select "textarea[name=?]", "family[comments]"
    end
  end
end
