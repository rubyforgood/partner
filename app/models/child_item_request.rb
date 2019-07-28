class ChildItemRequest < ApplicationRecord
  belongs_to :item_request
  belongs_to :child
end
