class PartnerRequest < ApplicationRecord
  belongs_to :partner, dependent: :destroy

  has_many :items, dependent: :destroy
  accepts_nested_attributes_for :items, allow_destroy: true, reject_if: proc { |attributes| attributes['quantity'].blank? }

  validates_presence_of :partner

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
    hsh = {}
    items.each {|item| hsh[item.name] = item.quantity }
    hsh
  end
end
