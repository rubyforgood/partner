require 'rails_helper'

RSpec.describe ImpactStory, type: :model do
  it "returns the first part of the content according to the given limit" do
    impact_story = 
      create(:impact_story, title: "For Testing", content: "Making some long content that needs to be shortened according to a given limit")
    expect("Making some long con…").to eq(impact_story.blurb(20))
  end
end
