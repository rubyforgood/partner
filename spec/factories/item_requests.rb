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

    factory :item_request_with_child_item_requests do
      transient do
        # This is loaded before the database and migratinos are run. If we use
        # Child.new it doesn't allow the db to be created.
        # TODO: Figure out what's going on here.
        child { OpenStruct.new }
        # child OpenStruct.new
      end

      after(:create) do |item_request, evaluator|
        evaluator.children.each do |child|
          create(:child_item_request, child: child, item_request: item_request)
        end
      end
    end
  end
end
