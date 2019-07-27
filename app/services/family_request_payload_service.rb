# Returns payload to be sent to DiaperBank via an API request.
class FamilyRequestPayloadService
  def self.execute(children:, partner:)
    new(children: children, partner: partner).execute
  end

  attr_reader :partner, :children
  def initialize(children:, partner:)
    @children = children
    @partner = partner
  end

  def execute
    {
      organization_id: partner.diaper_bank_id,
      partner_id: partner.id,
      requested_items: requested_items
    }.to_json
  end

  private

  def requested_items
    items_count_map.map { |item, count| { item_id: item, person_count: count } }
  end

  def items_count_map
    children.each_with_object({}) do |child, map|
      map[child.item_needed_diaperid] ||= 0
      map[child.item_needed_diaperid] += 1
    end
  end
end
