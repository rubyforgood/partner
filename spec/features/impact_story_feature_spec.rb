require "rails_helper"

describe ImpactStory, type: :feature, include_shared: true, js: true do
    let(:partner) { create(:partner, :verified, id: 3) }
    let(:user) { create(:user, partner: partner) }

    before do
        Flipper[:impact_story_requests].enable(partner)
        sign_in(user)
        visit(root_path)
    end

    scenario "User can see a list of impact stories" do
        diaper_type = "Magic diaper"
        stub_request(:any, "#{ENV["DIAPERBANK_ENDPOINT"]}/partner_requests/#{partner.id}")
          .to_return(body: [{ id: 1, name: diaper_type }].to_json, status: 200)
        
        impact_stories = [
            create(:impact_story, title: "Title1", content: "Content 1", partner: partner),
            create(:impact_story, title: "Title2", content: "Content 2", partner: partner)
        ].reverse

        click_link "Share Our Impact"
        impact_stories.each.with_index do |story, index|
            within "tbody" do
                expect(find("tr:nth-child(#{index + 1}) td:nth-child(1)"))
                    .to have_text(story.title)
                expect(find("tr:nth-child(#{index + 1}) td:nth-child(2)"))
                    .to have_text(story.created_at.strftime("%B %-d %Y"))
                expect(find("tr:nth-child(#{index + 1}) td:nth-child(3)"))
                    .to have_text(story.content)
            end
        end
    end
end
