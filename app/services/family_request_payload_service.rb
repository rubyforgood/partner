# Returns payload to be sent to DiaperBank via an API request.
class FamilyRequestPayloadService
  def self.execute(children:, partner:)
    new(children: children, partner: partner).execute
  end

  def initialize(children:, partner:)
    @children = children
    @partner = partner
  end

  def execute
    FamilyRequest.new({ items_attributes: requested_items }, partner: @partner)
  end

  private

  def requested_items
    children_grouped_by_diaperid = @children.group_by(&:item_needed_diaperid)
    items_count_map.map do |item, count|
      item_children = children_grouped_by_diaperid[item].to_a

      [nil, { item_id: item, person_count: count, children: item_children }]
    end
  end

  def items_count_map
    @children.each_with_object({}) do |child, map|
      map[child.item_needed_diaperid] ||= 0
      map[child.item_needed_diaperid] += 1
    end
  end
end
