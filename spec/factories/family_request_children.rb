# == Schema Information
#
# Table name: family_request_children
#
#  id                :bigint(8)        not null, primary key
#  family_request_id :bigint(8)
#  child_id          :bigint(8)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

FactoryBot.define do
  factory :family_request_child do
    family_request { nil }
    child { nil }
  end
end
