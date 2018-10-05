require "rails_helper"

describe Partner, type: :model do
  it "make name required" do
    partner = FactoryBot.build(:partner, email: nil)

    expect(partner).to_not be_valid

    partner.email = "partner@email.com"

    expect(partner).to be_valid
  end
end