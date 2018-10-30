class PartnerRequest < ApplicationRecord
  belongs_to :partner, dependent: :destroy

  has_many :items, dependent: :destroy
  accepts_nested_attributes_for :items, allow_destroy: true, reject_if: proc { |attributes| attributes['quantity'].blank? }

  validates_presence_of :partner
end
