# == Schema Information
#
# Table name: child_item_requests
#
#  id                          :bigint(8)        not null, primary key
#  child_id                    :bigint(8)
#  item_request_id             :bigint(8)
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  picked_up                   :boolean          default(FALSE)
#  quantity_picked_up          :integer
#  picked_up_item_diaperid     :integer
#  authorized_family_member_id :integer
#

class ChildItemRequest < ApplicationRecord
  belongs_to :item_request
  belongs_to :child
  belongs_to :authorized_family_member, optional: true

  def quantity
    item_request.quantity.to_i / item_request.children.size
  end

  def ordered_item_diaperid
    item_request.item_id
  end
end
