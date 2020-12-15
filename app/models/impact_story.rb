# == Schema Information
#
# Table name: impact_stories
#
#  id                  :bigint(8)        not null, primary key
#  partner_id          :bigint(8)
#  title               :string           not null
#  content             :text             not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class ImpactStory < ApplicationRecord
  belongs_to :partner

  validates :title, :content, presence: true

  def blurb(limit)
    content.truncate(limit, separator: ' ')
  end
end
