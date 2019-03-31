FactoryBot.define do
  factory :item_request do
    name { POSSIBLE_ITEMS.keys.sample(1).first }
    quantity { rand(1..1000) }
    partner_request
  end
end
