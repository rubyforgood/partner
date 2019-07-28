class ChildItemRequest < ApplicationRecord
  belongs_to :item_request
  belongs_to :child

  def quantity
    item_request.quantity.to_i / item_request.children.size
  end
end
