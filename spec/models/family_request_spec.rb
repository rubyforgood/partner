# == Schema Information
#
# Table name: family_requests
#
#  id         :bigint(8)        not null, primary key
#  partner_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sent       :boolean
#

require "rails_helper"

RSpec.describe FamilyRequest, type: :model do
  it { is_expected.to validate_presence_of(:partner) }

  it { should have_many(:family_request_children).dependent(:destroy) }

  it { should have_many(:children).through(:family_request_children) }

  describe "#export_json" do
    let(:partner) { create(:partner) }
    let(:family_request) { create(:family_request, partner: partner) }
    it "should return a JSON format" do
      result = {
        organization_id: partner.id,
        partner_id: partner.id,
        requested_items: []
      }.to_json

      expect(family_request.export_json).to eql result
    end
  end
end
