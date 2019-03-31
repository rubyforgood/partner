require "rails_helper"

RSpec.describe "children/index", type: :view do
  before(:each) do
    assign(:children, [
             Child.create!(
               first_name: "First Name",
               last_name: "Last Name",
               gender: "Gender",
               child_lives_with: "",
               race: "",
               agency_child_id: "Agency Child",
               health_insurance: "",
               item_needed: "Item Needed",
               comments: "MyText"
             ),
             Child.create!(
               first_name: "First Name",
               last_name: "Last Name",
               gender: "Gender",
               child_lives_with: "",
               race: "",
               agency_child_id: "Agency Child",
               health_insurance: "",
               item_needed: "Item Needed",
               comments: "MyText"
             )
           ])
  end

  it "renders a list of children" do
    render
    assert_select "tr>td", text: "First Name".to_s, count: 2
    assert_select "tr>td", text: "Last Name".to_s, count: 2
    assert_select "tr>td", text: "Gender".to_s, count: 2
    assert_select "tr>td", text: "".to_s, count: 2
    assert_select "tr>td", text: "".to_s, count: 2
    assert_select "tr>td", text: "Agency Child".to_s, count: 2
    assert_select "tr>td", text: "".to_s, count: 2
    assert_select "tr>td", text: "Item Needed".to_s, count: 2
    assert_select "tr>td", text: "MyText".to_s, count: 2
  end
end
