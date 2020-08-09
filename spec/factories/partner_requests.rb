# == Schema Information
#
# Table name: partner_requests
#
#  id              :bigint(8)        not null, primary key
#  comments        :text
#  partner_id      :bigint(8)
#  organization_id :bigint(8)
#  sent            :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  for_families    :boolean
#

FactoryBot.define do
  factory :partner_request do
    comments { Faker::Quote.matz }
    partner
    sequence(:organization_id)

    trait(:sent) do
      sent { true }
    end

    factory :partner_request_with_item_requests do
      transient do
        item_requests_count { 2 }
      end

      after(:create) do |partner_request, evaluator|
        create_list(:item_request, evaluator.item_requests_count, partner_request: partner_request)
      end
    end

    factory :partner_request_for_families do
      transient do
        children { [] }
        item_requests_count { 2 }
      end

      for_families { true }

      after(:create) do |partner_request, evaluator|
        create_list(
          :item_request_with_child_item_requests,
          evaluator.item_requests_count,
          partner_request: partner_request,
          child: evaluator.children.sample(1)
        )
      end
    end
  end
end
