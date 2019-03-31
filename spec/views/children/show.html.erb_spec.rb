require "rails_helper"

RSpec.describe "children/show", type: :view do
  before(:each) do
    @child = assign(:child, Child.create!(
                              first_name: "First Name",
                              last_name: "Last Name",
                              gender: "Gender",
                              child_lives_with: "",
                              race: "",
                              agency_child_id: "Agency Child",
                              health_insurance: "",
                              item_needed: "Item Needed",
                              comments: "MyText"
                            ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/First Name/)
    expect(rendered).to match(/Last Name/)
    expect(rendered).to match(/Gender/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/Agency Child/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Item Needed/)
    expect(rendered).to match(/MyText/)
  end
end
