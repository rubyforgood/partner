require 'rails_helper'

RSpec.describe "ImpactStories", type: :request do
    let(:partner) { create(:partner) }
    let!(:user) { create(:user, partner: partner) }

    before do
        sign_in user
    end

    describe "GET #index" do
      it "return http sucess" do
        get impact_stories_path
  
        expect(response).to have_http_status(:ok)
      end
    end
  
    describe "GET #new" do
      it "should return status code 200" do
        get new_impact_story_path
  
        expect(response).to have_http_status :ok
      end
    end
  
    describe "POST #create" do
      it "should create and redirect to impact_story_path" do
        post impact_stories_path, params: { impact_story: attributes_for(:impact_story) }
  
        impact_story = ImpactStory.select(:id).last
  
        expect(response).to redirect_to(impact_story_path(impact_story.id))
        expect(request.flash[:notice]).to eql "Impact Story was successfully created."
      end
    end
  
    describe "PUT #update" do
      let(:impact_story) { create(:impact_story, partner: partner) }
  
      it "should update and redirect to impact_story_path" do
        put impact_story_path(impact_story), params: { impact_story: attributes_for(:impact_story) }
  
        expect(response).to redirect_to(impact_story_path(impact_story.id))
        expect(request.flash[:notice]).to eql "Impact Story was successfully updated."
      end
    end
end
