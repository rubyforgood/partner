FactoryBot.define do
  factory :partner_request do
    comments { Faker::Matz.quote }
    partner
    sequence(:organization_id)

    trait(:sent) do
      sent { true }
    end

    factory :partner_request_with_items do
      transient do
        items_count { 2 }
      end

      after(:create) do |partner_request, evaluator|
        create_list(:item, evaluator.items_count, partner_request: partner_request)
      end
    end
  end
end
