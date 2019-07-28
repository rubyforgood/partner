RSpec.shared_context "diaperbank routes", shared_context: :metadata do
  def diaperbank_routes
    DiaperBankClient::Routes.instance
  end
end

RSpec.shared_context "stubs", shared_context: :metadata do
  def stub_successful_items_partner_request
    stub_request(
      :any,
      "#{ENV["DIAPERBANK_ENDPOINT"]}/partner_requests/#{partner.id}"
    ).to_return(
      body: [
        {
          id: 1,
          name: "Magic diaper"
        },
        {
          id: 2,
          name: "Fantastic diaper"
        }
      ].to_json,
      status: 200
    )
  end

  def stub_successful_family_request
    diaper_bank_default_quantity = 50
    stub_request(
      :any,
      "#{ENV["DIAPERBANK_ENDPOINT"]}/family_requests/"
    ).to_return(
      body: {
        "partner_id" => partner.id,
        "organization_id" => partner.id,
        "requested_items": [
          {
            "item_name" => "Big Diaper",
            "item_id" => 1,
            "count" => 2 * diaper_bank_default_quantity
          },
          {
            "item_name" => "Small Diaper",
            "item_id" => 2,
            "count" => 3 * diaper_bank_default_quantity
          }
        ]
      }.to_json,
      status: 200)
  end
end


RSpec.configure do |config|
  config.include_context "diaperbank routes", include_shared: true
  config.include_context "stubs", include_shared: true
end
