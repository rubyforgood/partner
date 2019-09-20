require "rails_helper"

RSpec.describe PartnerService, type: :request do
  describe "#create" do
    it "shoud return success" do
      response = PartnerService.new
      expect(response.create(params: { diaper_bank_id: 100, diaper_partner_id: 100, name: "Alexander Billy" })).to be_truthy
    end
  end
end
