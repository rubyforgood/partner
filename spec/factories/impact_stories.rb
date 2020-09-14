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

FactoryBot.define do
  factory :impact_story do
    title { Faker::Lorem.word }
    content { Faker::Lorem.paragraph }
    partner
  end
end
