module DiaperBankClient
  def self.post(partner_id)
    diaper_post_request(
      routes.partner_approvals,
      { partner: { diaper_partner_id: partner_id } }.to_json
    ).body
  end

  def self.get_available_items(diaper_bank_id, partner_id)
    partner_request_uri = routes.partner_requests(diaper_bank_id)
    partner_request_uri.query = "partner_id=#{partner_id}"
    response = diaper_get_request(partner_request_uri)
    if response.code.to_i == 200
      JSON.parse(response.body)
    else
      []
    end
  end

  def self.send_family_request(payload)
    response = diaper_post_request(routes.family_requests, payload.to_json)
    response.body ? JSON.parse(response.body) : nil
  end

  def self.request_submission_post(partner_request_id)
    return unless PartnerRequest.exists?(partner_request_id)

    diaper_post_request(
      routes.partner_requests,
      PartnerRequest.find(partner_request_id).export_json
    ).body
  end

  def self.https(uri)
    # Use a uri with `http://` to not use ssl.
    Net::HTTP.new(uri.host, uri.port).tap do |http|
      http.use_ssl = uri.scheme.eql?("https")
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end

  def self.diaper_post_request(uri, body)
    https(uri).request(post_request(uri: uri, body: body))
  end

  def self.diaper_get_request(uri)
    request = Net::HTTP::Get.new(uri)
    request["Content-Type"] = "application/json"
    request["X-Api-Key"] = ENV["DIAPERBANK_KEY"]
    https(uri).request(request)
  end

  def self.post_request(uri:, body:, content_type: "application/json")
    request = Net::HTTP::Post.new(uri)
    request.body = body
    request["Content-Type"] = content_type
    request["X-Api-Key"] = ENV["DIAPERBANK_KEY"]
    request
  end

  def self.routes
    Routes.instance
  end

  class Routes
    include Singleton

    def initialize
      @endpoint = ENV["DIAPERBANK_ENDPOINT"]
    end

    [:partner_requests, :family_requests, :partner_approvals].each do |path|
      define_method(path) do |id = ""|
        URI("#{@endpoint}/#{path}/#{id}")
      end
    end
  end
end
