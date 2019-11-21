require "rails_helper"

describe ChildrenController, type: :controller do
  let(:family)  { create :family}
  let(:partner) { create :partner, name: "new partner", family_ids: [family.id] }
  let!(:child) { create :child, family: family }
  let(:user) { create :user, partner: partner }

  before do
    sign_in user
  end
  describe "GET #index" do
    describe "when responding csv" do
      subject { get :index, format: :csv }

      it "responds correct Content-Type" do
        expect(subject.content_type).to eq "text/csv"
      end
    end
  end
end