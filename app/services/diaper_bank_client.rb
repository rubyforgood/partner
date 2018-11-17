module DiaperBankClient
  def self.post(partner_id)
    return unless Rails.env.production?

    partner = { partner:
      { diaper_partner_id: partner_id } }

    uri = URI(ENV["DIAPERBANK_APPROVAL_URL"])

    response = https(uri).request(post_request(uri: uri, body: partner.to_json))

    response.body
  end

  def self.request_submission_post(partner_request_id)
    return unless Rails.env.production?
    return unless PartnerRequest.exists?(partner_request_id)

    uri = URI(ENV["DIAPERBANK_PARTNER_REQUEST_URL"])
    body = PartnerRequest.find(partner_request_id).export_json

    response = https(uri).request(post_request(uri: uri, body: body))

    response.body
  end

  def self.https(uri)
    Net::HTTP.new(uri.host, uri.port).tap do |http|
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end

  def self.post_request(uri:, body:, content_type: "application/json")
    req = Net::HTTP::Post.new(uri)
    req.body = body
    req["Content-Type"] = content_type
    req["X-Api-Key"] = ENV["DIAPERBANK_KEY"]
    req
  end
end
