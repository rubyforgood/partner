require "rails_helper"

describe Partner, type: :model do
  it "make name required" do
    partner = build(:partner, email: nil)

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

  describe "export_json" do
    it "returns a hash" do
      partner = build(:partner)
      expect(partner.export_json).to be_a(Hash)
    end

    context "a partner with a form 990" do
      it "returns a hash with a value for form_990_link" do
        partner = build(:partner, :with_990_attached)
        expect(partner.export_json.dig(:stability, :form_990_link)).to include("f990.pdf")
      end
    end

    context "a partner without a form 990" do
      it "returns a hash with an emptry string value for form_990_link" do
        partner = build(:partner)
        expect(partner.export_json.dig(:stability, :form_990_link)).to eq("")
      end
    end

    context "a partner with a proof of status" do
      it "returns a hash with a value for proof_of_agency_status" do
        partner = build(:partner, :with_status_proof)
        expect(partner.export_json[:proof_of_agency_status]).to include("status_proof.pdf")
      end
    end

    context "a partner without a proof of status" do
      it "returns a hash with an emptry string value for proof_of_agency_status" do
        partner = build(:partner)
        expect(partner.export_json[:proof_of_agency_status]).to eq("")
      end
    end

    context "a partner with additional documents" do
      it "returns a hash with an array of documents" do
        partner = build(:partner, :with_other_documents)
        expect(partner.export_json[:documents]).to be_a Array
        expect(partner.export_json[:documents]).not_to be_empty
        expect(partner.export_json[:documents].first).to have_key(:document_link)
      end

      it "contains an attachment path as an element of the doc" do
        partner = build(:partner, :with_other_documents)
        document_link_list = partner.export_json[:documents].map { |doc| doc.dig(:document_link) }
        document_path_regex = %r(\/rails\/active_storage\/blobs\/\w*\W*\w*\/document\d\.pdf)
        expect(document_link_list.first).to match(document_path_regex)
      end
    end
  end
end
