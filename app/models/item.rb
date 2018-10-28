class Item < ApplicationRecord
  belongs_to :partner_request, optional: true
  validates_presence_of :name, :quantity
  validates :quantity, numericality: {only_integer: true}
end
