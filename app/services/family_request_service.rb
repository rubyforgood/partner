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
      item_requests_attributes: response.fetch("requested_items").map do |item|
        {
          name: item["item_name"],
          item_id: item["item_id"],
          quantity: item["count"],
        }
      end
    }
  end
end
