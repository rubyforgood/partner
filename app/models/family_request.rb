class FamilyRequest
  include ActiveModel::Model

  attr_accessor :comments, :partner
  attr_reader :items

  def initialize(params, partner: nil, initial_items: nil)
    @items = [Item.new] * initial_items if initial_items
    @partner = partner
    super params
  end

  def items_attributes=(attributes)
    @items = attributes.map do |_, params|
      Item.new(params.slice(:item_id, :people_count))
    end
  end

  def as_payload
    {
      organization_id: partner&.diaper_bank_id,
      partner_id: partner&.diaper_partner_id,
      request_items: items.as_json,
    }
  end

  class Item
    include ActiveModel::Model

    attr_accessor :item_id, :people_count
  end
end
