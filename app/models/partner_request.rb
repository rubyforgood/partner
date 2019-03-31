class PartnerRequest < ApplicationRecord
  belongs_to :partner

  has_many :item_requests, dependent: :destroy
  accepts_nested_attributes_for :item_requests, allow_destroy: true, reject_if: proc { |attributes| attributes["quantity"].blank? }

  validates :partner, presence: true
  validates_associated :item_requests
  def export_json
    {
      request: {
        partner_id: partner.diaper_partner_id,
          organization_id: partner.diaper_bank_id,
          comments: comments,
          request_items: formatted_item_requests_hash(item_requests)
      }
    }.to_json
  end

  def formatted_item_requests_hash(item_requests)
    item_requests.each_with_object({}) { |item_request, hsh| hsh[item_request.name] = item_request.quantity }
  end
end
