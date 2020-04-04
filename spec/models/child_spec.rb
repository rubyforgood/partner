# == Schema Information
#
# Table name: children
#
#  id                   :bigint(8)        not null, primary key
#  first_name           :string
#  last_name            :string
#  date_of_birth        :date
#  gender               :string
#  child_lives_with     :jsonb
#  race                 :jsonb
#  agency_child_id      :string
#  health_insurance     :jsonb
#  comments             :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  family_id            :bigint(8)
#  item_needed_diaperid :integer
#  active               :boolean          default(TRUE)
#  archived             :boolean
#

require "rails_helper"

RSpec.describe Child, type: :model do
  it "scopes children to active" do
    create(:child, active: true)
    create(:child, active: false)
    expect(described_class.all.active.count).to eq(1)
  end
  describe "export_json" do
    it "returns a hash" do
      child = build(:child)
      expect(child.export_json).to be_a(Hash)
    end
  end
end
