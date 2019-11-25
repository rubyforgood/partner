require "rails_helper"

describe FamiliesController, type: :controller do
  let(:partner) { create :partner, name: "new partner" }
  let(:user) { create :user, partner: partner }
  let!(:family) { create :family, guardian_first_name: "new family", partner: partner }

  before do
    user.partner = partner
    sign_in user
  end

  describe "#index" do
    context "when responding csv" do
      subject { get :index, format: :csv }

      it "responds correct Content-Type" do
        expect(subject.headers["Content-Type"]).to eq "text/csv; charset=utf-8"
      end
    end

    context "when responding html" do
      subject { get :index, format: :html }

      it "responds correct Content-Type" do
        expect(subject.headers["Content-Type"]).to eq "text/html; charset=utf-8"
      end
    end
  end

  describe "#show" do
    it "retrieve a family" do
      get :show, params: { id: family.id }

      expect(assigns[:family].guardian_first_name).to eq("new family")
    end

    context "when the family does not exists" do
      let(:invalid_family) { "-1" }

      it "should not be successful" do
        get :show, params: { id: invalid_family }

        expect(response).not_to be_successful
      end
    end
  end

  describe "#create" do
    let(:family_params) { attributes_for :family }

    subject { post :create, params: { family: family_params, id: family.id } }

    it "should create a family", :aggregate_failures do
      expect { subject }.to change(Family, :count).by(1)
    end
  end

  describe "#update" do
    it "should update family name", :aggregate_failures do
      put :update, params: { id: family.id, family: { guardian_first_name: "new family name" } }

      expect(assigns[:family].guardian_first_name).to eq("new family name")
    end
  end

  describe "#delete" do
    subject { delete :destroy, params: { id: family.id } }

    it "should remove the family", :aggregate_failures do
      expect { subject }.to change(Family, :count).by(-1)
    end
  end
end
