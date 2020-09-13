# == Schema Information
#
# Table name: impact_stories
#
#  id                  :bigint(8)        not null, primary key
#  partner_id          :integer
#  title               :string
#  content             :text
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ImpactStory < ApplicationRecord
  belongs_to :partner

  def blurb(limit)
    if content.length > limit then "#{content[0, limit]}…" else content end
  end
end
