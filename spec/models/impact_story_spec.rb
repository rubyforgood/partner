require 'rails_helper'

RSpec.describe ImpactStory, type: :model do
  describe 'associations' do
    it { should belong_to(:partner).class_name('Partner') }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
  end

  describe '#blurb' do
    subject { impact_story.blurb(10) }
    let(:impact_story) { create(:impact_story, title: Faker::Lorem.word, content: Faker::Lorem.paragraph) }

    it "returns truncates the content to less than or equal to 10 characters" do
      expect(subject.length).to be <= 20
    end
  end
end
