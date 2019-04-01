require "rails_helper"

RSpec.describe ItemRequest, type: :model do
  describe "a valid ItemRequest" do
    it "requires a name within the list of POSSIBLE_ITEMS keys" do
      expect(build(:item_request)).to be_valid
      expect(build(:item_request, name: "foo")).not_to be_valid
    end

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

    it "requires a name" do
      expect(build(:item_request, name: nil)).not_to be_valid
    end
  end
end
