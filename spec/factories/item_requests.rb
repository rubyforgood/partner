FactoryBot.define do
  factory :item_request do
    name { ItemRequest::POSSIBLE_ITEMS.sample }
    quantity { rand(1..1000) }
    partner_request
  end
end
