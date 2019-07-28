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

class ItemRequest < ApplicationRecord
  belongs_to :partner_request, optional: true
  validates :quantity, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  has_many :child_item_requests
  has_many :children, through: :child_item_requests
end
