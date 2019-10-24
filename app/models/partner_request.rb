# == Schema Information
#
# Table name: partner_requests
#
#  id              :bigint(8)        not null, primary key
#  comments        :text
#  partner_id      :bigint(8)
#  organization_id :bigint(8)
#  sent            :boolean          default(FALSE), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class PartnerRequest < ApplicationRecord
  belongs_to :partner

  has_many :item_requests, dependent: :destroy
  accepts_nested_attributes_for :item_requests, allow_destroy: true,
    reject_if: proc { |attributes| attributes["quantity"].blank? }
  validates :item_requests, presence: true, if: proc { |a| a.comments.blank? }
  has_many :child_item_requests, through: :item_requests

  validates :partner, presence: true
  validates_associated :item_requests

  scope :most_recent, ->(integer) { order(:created_at).limit(integer).offset(PartnerRequest.all.count - integer) }

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
    item_requests.map { |item| { "item_id" => item.item_id, "quantity" => item.quantity } }
  end
end
