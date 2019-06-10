# == Schema Information
#
# Table name: item_requests
#
#  id                 :bigint(8)        not null, primary key
#  name               :string
#  quantity           :string
#  partner_request_id :bigint(8)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  partner_key        :string
#  item_id            :integer
#

FactoryBot.define do
  factory :item_request do
    sequence(:item_id) { |n| n }
    quantity { rand(1..1000) }
    partner_request
  end
end
