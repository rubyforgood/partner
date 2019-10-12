# == Schema Information
#
# Table name: family_requests
#
#  id         :bigint(8)        not null, primary key
#  partner_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sent       :boolean
#

class FamilyRequest < ApplicationRecord
  belongs_to :partner
  has_many :family_request_children, dependent: :destroy
  has_many :children, through: :family_request_children

  validates :partner, presence: true

  def export_json
    items_count_map = children.each_with_object({}) do |child, map|
      map[child.item_needed_diaperid] ||= 0
      map[child.item_needed_diaperid] += 1
    end

    requested_items = items_count_map.map do |item, count|
      { item_id: item, person_count: count }
    end

    {
      organization_id: partner.diaper_bank_id,
      partner_id: partner.diaper_partner_id,
      requested_items: requested_items
    }.to_json
  end
end
