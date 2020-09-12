class ImpactStoryMailerPreview < ActionMailer::Preview
    def impact_story_email
        ImpactStoryMailer.impact_story_email(ImpactStory.first)
    end
end
