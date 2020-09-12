class ImpactStoriesController < ApplicationController
    before_action :authenticate_user!

    def index
        @impact_stories = current_partner.impact_stories
    end

    def show
        @impact_story = current_partner.impact_stories.find(params[:id])
    end

    def new
        @impact_story = current_partner.impact_stories.new
    end

    def create
        @impact_story = current_partner.impact_stories.new(impact_story_params)
        
        if @impact_story.save
            redirect_to @impact_story, notice: "Impact Story was successfully created."
        else
            render :new
        end
    end

    def edit
        @impact_story = current_partner.impact_stories.find(params[:id])
    end

    def update
        @impact_story = current_partner.impact_stories.find(params[:id])
        
        if @impact_story.update(impact_story_params)
            redirect_to @impact_story, notice: "Impact Story was successfully updated."
        else
            render :edit
        end
    end

    def email
        ImpactStoryMailer.impact_story_email(current_partner.impact_stories.find(params[:id])).deliver_now
    end

    private

    def impact_story_params
        params.require(:impact_story).permit(:title, :content)
    end
end
