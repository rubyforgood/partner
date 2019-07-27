# == Schema Information
#
# Table name: family_requests
#
#  id         :bigint(8)        not null, primary key
#  partner_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sent       :boolean
#

FactoryBot.define do
  factory :family_request do
    partner { nil }

    transient do
      children []
    end

    trait(:sent) do
      sent { true }
    end

    after(:create) do |family_request, evaluator|
      evaluator.children.each do |child|
        family_request.children << child
      end
    end
  end
end
