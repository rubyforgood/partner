FactoryBot.define do
  factory :item_request do
    sequence(:item_id) { |n| n }
    quantity { rand(1..1000) }
    partner_request
  end
end
