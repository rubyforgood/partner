class PartnerRequest < ApplicationRecord
  belongs_to :partner

  has_many :items, dependent: :destroy
  accepts_nested_attributes_for :items, allow_destroy: true, reject_if: proc { |attributes| attributes["quantity"].blank? }

  validates :partner, presence: true
  validates_associated :items
  def export_json
    {
      request: {
        partner_id: partner.diaper_partner_id,
          organization_id: partner.diaper_bank_id,
          comments: comments,
          request_items: formatted_items_hash(items)
      }
    }.to_json
  end

  def formatted_items_hash(items)
    items.each_with_object({}) { |item, hsh| hsh[item.name] = item.quantity }
  end
end
