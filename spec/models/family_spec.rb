# == Schema Information
#
# Table name: families
#
#  id                        :bigint(8)        not null, primary key
#  guardian_first_name       :string
#  guardian_last_name        :string
#  guardian_zip_code         :string
#  guardian_country          :string
#  guardian_phone            :string
#  agency_guardian_id        :string
#  home_adult_count          :integer
#  home_child_count          :integer
#  home_young_child_count    :integer
#  sources_of_income         :jsonb
#  guardian_employed         :boolean
#  guardian_employment_type  :jsonb
#  guardian_monthly_pay      :decimal(, )
#  guardian_health_insurance :jsonb
#  comments                  :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  partner_id                :bigint(8)
#  military                  :boolean          default(FALSE)
#

require "rails_helper"

RSpec.describe Family, type: :model do
  it { is_expected.to have_many(:authorized_family_members).dependent(:destroy) }

  it "concatenates guardian first and last names" do
    family =
      create(:family, guardian_first_name: "John", guardian_last_name: "Wick")
    expect("John Wick").to eq(family.guardian_display_name)
  end

  it "when a family is created the first authorized family member is created" do
    expect { create(:family) }.to change { AuthorizedFamilyMember.count }.by(1)
  end

  describe "export_json" do
    it "returns a hash" do
      family = build(:family)
      expect(family.export_json).to be_a(Hash)
    end
  end
end
