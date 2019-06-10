# == Schema Information
#
# Table name: item_requests
#
#  id                 :bigint(8)        not null, primary key
#  name               :string
#  quantity           :string
#  partner_request_id :bigint(8)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  partner_key        :string
#  item_id            :integer
#

require "rails_helper"

RSpec.describe ItemRequest, type: :model do
  describe "a valid ItemRequest" do
    it "requires a quantity greater than or equal to 1" do
      expect(build(:item_request, quantity: 1)).to be_valid
      expect(build(:item_request, quantity: 3)).to be_valid
    end
  end

  describe "an invalid ItemRequest" do
    it "requires a quantity greater than or equal to 1" do
      expect(build(:item_request, quantity: 0)).not_to be_valid
    end

    it "requires a quantity with integer value only" do
      expect(build(:item_request, quantity: 1.2)).not_to be_valid
    end
  end
end
