class FamilyRequest
  include ActiveModel::Model

  attr_accessor :comments
  attr_reader :items

  def initialize(params, initial_items: nil)
    @items = [Item.new] * initial_items if initial_items
    super params
  end

  def items_attributes=(attributes)
    @items = attributes.map do |_, params|
      Item.new(params.slice(:item_id, :people_count))
    end
  end

  class Item
    include ActiveModel::Model

    attr_accessor :item_id, :people_count
  end
end
