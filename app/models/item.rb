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

class Item < ApplicationRecord
  belongs_to :partner_request, optional: true
  validates :name, :quantity, presence: true
  validates :name, inclusion: { in: POSSIBLE_ITEMS.keys }
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end
