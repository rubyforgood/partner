require "rails_helper"

describe Partner, type: :model do
  it "make name required" do
    partner = FactoryBot.build(:partner, email: nil)

    expect(partner).to_not be_valid

    partner.email = "partner@email.com"

    expect(partner).to be_valid
  end

  describe "verified?" do
    context "partner with a verfied status" do
      it "returns a partner verified status as true" do
        partner = build(:partner, partner_status: "Verified")
        expect(partner.verified?).to be true
      end
    end

    context "partner with a pending status" do
      it "returns a partner verified status as false" do
        partner = build(:partner)
        expect(partner.verified?).to be false
      end
    end

    context "partner with an unknown status" do
      it "returns a partner verified status as false" do
        partner = build(:partner, partner_status: "")
        expect(partner.verified?).to be false
      end
    end
  end

  describe "pending?" do
    context "partner with a verfied status" do
      it "returns a partner pending status as false" do
        partner = build(:partner, partner_status: "Verified")
        expect(partner.pending?).to be false
      end
    end

    context "partner with a pending status" do
      it "returns a partner pending status as true" do
        partner = build(:partner)
        expect(partner.pending?).to be true
      end
    end

    context "partner with an unknown status" do
      it "returns a partner pending status as false" do
        partner = build(:partner, partner_status: "foo")
        expect(partner.pending?).to be false
      end
    end
  end
end
