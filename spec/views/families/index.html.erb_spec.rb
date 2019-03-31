require "rails_helper"

RSpec.describe "families/index", type: :view do
  before(:each) do
    assign(:families, [
             Family.create!(
               guardian_first_name: "Guardian First Name",
               guardian_last_name: "Guardian Last Name",
               guardian_zip_code: "Guardian Zip Code",
               guardian_country: "Guardian Country",
               guardian_phone: "Guardian Phone",
               agency_guardian_id: "Agency Guardian",
               home_adult_count: 2,
               home_child_count: 3,
               home_young_child_count: 4,
               sources_of_income: "",
               guardian_employed: false,
               guardian_employment_type: "",
               guardian_monthly_pay: "9.99",
               guardian_health_insurance: "",
               comments: "MyText"
             ),
             Family.create!(
               guardian_first_name: "Guardian First Name",
               guardian_last_name: "Guardian Last Name",
               guardian_zip_code: "Guardian Zip Code",
               guardian_country: "Guardian Country",
               guardian_phone: "Guardian Phone",
               agency_guardian_id: "Agency Guardian",
               home_adult_count: 2,
               home_child_count: 3,
               home_young_child_count: 4,
               sources_of_income: "",
               guardian_employed: false,
               guardian_employment_type: "",
               guardian_monthly_pay: "9.99",
               guardian_health_insurance: "",
               comments: "MyText"
             )
           ])
  end

  it "renders a list of families" do
    render
    assert_select "tr>td", text: "Guardian First Name".to_s, count: 2
    assert_select "tr>td", text: "Guardian Last Name".to_s, count: 2
    assert_select "tr>td", text: "Guardian Zip Code".to_s, count: 2
    assert_select "tr>td", text: "Guardian Country".to_s, count: 2
    assert_select "tr>td", text: "Guardian Phone".to_s, count: 2
    assert_select "tr>td", text: "Agency Guardian".to_s, count: 2
    assert_select "tr>td", text: 2.to_s, count: 2
    assert_select "tr>td", text: 3.to_s, count: 2
    assert_select "tr>td", text: 4.to_s, count: 2
    assert_select "tr>td", text: "".to_s, count: 2
    assert_select "tr>td", text: false.to_s, count: 2
    assert_select "tr>td", text: "".to_s, count: 2
    assert_select "tr>td", text: "9.99".to_s, count: 2
    assert_select "tr>td", text: "".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
