class ItemRequest < ApplicationRecord
  RAW_JSON = '[
    {"id":411,"partner_key":"adult_lxl","name":"Adult Briefs (Large/X-Large)"},
    {"id":412,"partner_key":"adult_ml","name":"Adult Briefs (Medium/Large)"}
    ]'.freeze
  POSSIBLE_ITEMS = JSON.parse(RAW_JSON)

  belongs_to :partner_request, optional: true
  validates :name, :quantity, presence: true
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end
