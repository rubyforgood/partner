require 'rails_helper'

describe Partner, :type => :model do
  it 'make name required' do
    partner = FactoryBot.build(:partner, name: nil)

    expect(partner).to_not be_valid

    partner.name = 'Partner A'

    expect(partner).to be_valid
  end
end