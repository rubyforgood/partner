class ImpactStoryMailer < ApplicationMailer
    default from: "info@partner.app"
    layout "mailer"
  
    def impact_story_email(impact_story)
        @impact_story = impact_story

        mail to: "something@example.com",
                subject: "New Impact Story From #{@impact_story.partner.name}"
    end
end