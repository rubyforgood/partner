# == Schema Information
#
# Table name: items
#
#  id                 :bigint(8)        not null, primary key
#  name               :string
#  quantity           :string
#  partner_request_id :bigint(8)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

FactoryBot.define do
  factory :item_request do
    name { POSSIBLE_ITEMS.keys.sample(1).first }
    quantity { rand(1..1000) }
    partner_request
  end
end
