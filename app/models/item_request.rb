class ItemRequest < ApplicationRecord
  belongs_to :partner_request, optional: true
  validates :name, :quantity, presence: true
  validates :name, inclusion: { in: POSSIBLE_ITEMS.keys }
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end
