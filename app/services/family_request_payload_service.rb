# Returns payload to be sent to DiaperBank via an API request.
class FamilyRequestPayloadService
  def self.execute(children:, partner:)
    new(children: children, partner: partner).execute
  end

  def initialize(children:, partner:)
    @request = FamilyRequest.new({ items_attributes: requested_items(children) }, partner: partner)
  end

  def execute
    @request.as_payload
  end

  private

  def requested_items(children)
    items_count_map(children).map do |item, count|
      [nil, { item_id: item, person_count: count }]
    end
  end

  def items_count_map(children)
    children.each_with_object({}) do |child, map|
      map[child.item_needed_diaperid] ||= 0
      map[child.item_needed_diaperid] += 1
    end
  end
end
