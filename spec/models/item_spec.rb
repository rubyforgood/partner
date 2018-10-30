require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'a valid Item' do
    it 'requires a name within the list of POSSIBLE_ITEMS keys' do
      expect(build(:item)).to be_valid
      expect(build(:item, name: 'foo')).not_to be_valid
    end

    it 'requires a quantity greater than or equal to 1' do
      expect(build(:item)).to be_valid
      expect(build(:item, quantity: 0)).not_to be_valid
    end
  end
end
