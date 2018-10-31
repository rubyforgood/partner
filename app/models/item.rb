class Item < ApplicationRecord
  belongs_to :partner_request, optional: true
  validates_presence_of :name, :quantity
  validates_inclusion_of :name, in: POSSIBLE_ITEMS.keys
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end
