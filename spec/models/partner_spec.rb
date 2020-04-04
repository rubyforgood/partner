# == Schema Information
#
# Table name: partners
#
#  id                         :bigint(8)        not null, primary key
#  diaper_bank_id             :integer
#  executive_director_name    :string
#  program_contact_name       :string
#  pick_up_name               :string
#  application_data           :text
#  diaper_partner_id          :integer
#  partner_status             :string           default("pending")
#  name                       :string
#  distributor_type           :string
#  agency_type                :string
#  agency_mission             :text
#  address1                   :string
#  address2                   :string
#  city                       :string
#  state                      :string
#  zip_code                   :string
#  website                    :string
#  facebook                   :string
#  twitter                    :string
#  founded                    :integer
#  form_990                   :boolean
#  program_name               :string
#  program_description        :text
#  program_age                :string
#  case_management            :boolean
#  evidence_based             :boolean
#  evidence_based_description :text
#  program_client_improvement :text
#  diaper_use                 :string
#  other_diaper_use           :string
#  currently_provide_diapers  :boolean
#  turn_away_child_care       :boolean
#  program_address1           :string
#  program_address2           :string
#  program_city               :string
#  program_state              :string
#  program_zip_code           :integer
#  max_serve                  :string
#  incorporate_plan           :text
#  responsible_staff_position :boolean
#  storage_space              :boolean
#  describe_storage_space     :text
#  trusted_pickup             :boolean
#  income_requirement_desc    :boolean
#  serve_income_circumstances :boolean
#  income_verification        :boolean
#  internal_db                :boolean
#  maac                       :boolean
#  population_black           :integer
#  population_white           :integer
#  population_hispanic        :integer
#  population_asian           :integer
#  population_american_indian :integer
#  population_island          :integer
#  population_multi_racial    :integer
#  population_other           :integer
#  zips_served                :string
#  at_fpl_or_below            :integer
#  above_1_2_times_fpl        :integer
#  greater_2_times_fpl        :integer
#  poverty_unknown            :integer
#  ages_served                :string
#  executive_director_phone   :string
#  executive_director_email   :string
#  program_contact_phone      :string
#  program_contact_mobile     :string
#  program_contact_email      :string
#  pick_up_method             :string
#  pick_up_phone              :string
#  pick_up_email              :string
#  distribution_times         :string
#  new_client_times           :string
#  more_docs_required         :string
#  sources_of_funding         :string
#  sources_of_diapers         :string
#  diaper_budget              :string
#  diaper_funding_source      :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  other_agency_type          :string
#

require "rails_helper"

describe Partner, type: :model, include_shared: true do
  it { is_expected.to have_many(:partner_requests).dependent(:destroy) }
  it { is_expected.to have_many(:users).dependent(:destroy) }

  describe "#approve_me" do
    let(:partner) { create(:partner) }
    it "changes the partner status to Submitted" do
      stub_request(:post, diaperbank_routes.partner_approvals).with(
        body: { partner: { diaper_partner_id: partner.id } }.to_json,
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
          "Content-Type" => "application/json",
          "Host" => "diaper.test",
          "User-Agent" => "Ruby",
          "X-Api-Key" => ENV["DIAPERBANK_KEY"]
        }
      ).to_return(status: 200, body: "", headers: {})
      expect { partner.approve_me }.to change { partner.partner_status }.from("pending").to("submitted")
    end

    it "posts the diaper partner id" do
      expect(DiaperBankClient).to receive(:post).with(partner.diaper_partner_id)
      partner.approve_me
    end
  end

  describe "#partials_to_show" do
    let(:partner) { create(:partner, diaper_bank_id: 100) }
    it 'has 10 partials when there are no displayable partials configured' do
      expect(partner.partials_to_show.size).to eq(10)
    end

    it 'displays the number of displayable partials when they are configured' do
      partner.diaper_bank_id = 100
      FactoryBot.create(:partner_form, diaper_bank_id: 100,
                        sections: %w[agency_information media_information agency_stability]
                        )
      expect(partner.partials_to_show.size).to eq(3)
    end
  end

  describe "verified?" do
    context "partner with a verfied status" do
      it "returns a partner verified status as true" do
        partner = build(:partner, partner_status: "verified")
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
        partner = build(:partner, partner_status: "verified")
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

  describe "export_hash" do
    it "returns a hash" do
      partner = build(:partner)
      expect(partner.export_hash).to be_a(Hash)
    end

    context "a partner with a form 990" do
      it "returns a hash with a value for form_990_link" do
        partner = build(:partner, :with_990_attached)
        expect(partner.export_hash.dig(:stability, :form_990_link)).to include("f990.pdf")
      end
    end

    context "a partner without a form 990" do
      it "returns a hash with an emptry string value for form_990_link" do
        partner = build(:partner)
        expect(partner.export_hash.dig(:stability, :form_990_link)).to eq("")
      end
    end

    context "a partner with a proof of status" do
      it "returns a hash with a value for proof_of_agency_status" do
        partner = build(:partner, :with_status_proof)
        expect(partner.export_hash[:proof_of_agency_status]).to include("status_proof.pdf")
      end
    end

    context "a partner without a proof of status" do
      it "returns a hash with an emptry string value for proof_of_agency_status" do
        partner = build(:partner)
        expect(partner.export_hash[:proof_of_agency_status]).to eq("")
      end
    end

    context "a partner with additional documents" do
      it "returns a hash with an array of documents" do
        partner = build(:partner, :with_other_documents)
        expect(partner.export_hash[:documents]).to be_a Array
        expect(partner.export_hash[:documents]).not_to be_empty
        expect(partner.export_hash[:documents].first).to have_key(:document_link)
      end

      it "contains an attachment path as an element of the doc" do
        partner = build(:partner, :with_other_documents)
        document_link_list = partner.export_hash[:documents].map { |doc| doc.dig(:document_link) }
        document_path_regex = %r(\/rails\/active_storage\/blobs\/\w*\W*\w*\/document\d\.pdf)
        expect(document_link_list.first).to match(document_path_regex)
      end
    end
  end

  describe "impact_metrics" do
    it "returns a hash" do
      partner = build(:partner)
      expect(partner.impact_metrics).to be_a(Hash)
    end

    it "returns a hash with family and children aggregate data" do
      partner = create(:partner, :with_families)
      expect(partner.impact_metrics[:families_served]).to eq(1)
      expect(partner.impact_metrics[:children_served]).to eq(1)
      expect(partner.impact_metrics[:family_zipcodes]).to eq(1)
    end
  end
end
