class FamilyRequestService
  def self.execute(request)
    new(request).execute
  end

  def initialize(request)
    @request = request
  end

  def execute
    @request.validate!
    response = DiaperBankClient.send_family_request(@request.as_payload)
    PartnerRequest.create! response_to_request_attrs(response)
  end

private

  def response_to_request_attrs(response)
    {
      sent: true, for_families: true,
      comments: @request.comments,
      partner_id: @request.partner.id,
      organization_id: response.slice("organization_id"),
      item_requests_attributes: response.fetch("requested_items").map(&method(:items_response_to_attrs))
    }
  end

  def items_response_to_attrs(response)
    item_children = @request.items
                            .filter {|item| response["item_id"].to_i.eql?(item.item_id) }
                            .flat_map(&:children)
    {
      name: response["item_name"],
      item_id: response["item_id"],
      quantity: response["count"],
      children: item_children,
    }
  end
end
