require "rails_helper"

describe ChildrenController, type: :controller do
  let(:family)  { create :family }
  let(:partner) { create :partner, name: "new partner", family_ids: [family.id] }
  let!(:child) { create :child, family: family }
  let(:user) { create :user, partner: partner }

  before do
    sign_in user
  end

  describe "#index" do
    context "when responding csv" do
      subject { get :index, format: :csv }

      it "responds correct Content-Type" do
        expect(subject.content_type).to eq "text/csv"
      end
    end

    context "when responding html" do
      subject { get :index, format: :html }

      it "responds correct Content-Type" do
        expect(subject.content_type).to eq "text/html"
      end
    end
  end

  describe "#show" do
    it "retrieve a child", :aggregate_failures do
      get :show, params: { id: child.id }

      expect(response).to be_successful
      expect(assigns[:child]).to eq(child)
    end

    context "when the child does not exists" do
      let(:invalid_child) { "-1" }

      it "should not be successful" do
        get :show, params: { id: invalid_child }

        expect(response).not_to be_successful
      end
    end
  end

  describe "#create" do
    let(:child_params) { attributes_for :child, family: family }

    subject { post :create, params: { child: child_params, family_id: family.id } }

    it "should create a child", :aggregate_failures do
      expect { subject }.to change(Child, :count).by(1)
    end
  end

  describe "#update" do
    it "should update first name", :aggregate_failures do
      put :update, params: { id: child.id, child: { first_name: "new name" } }

      expect(response.headers["Location"]).to eq("http://test.host/children/#{child.id}")
    end
  end

  describe "#destroy" do
    subject { delete :destroy, params: { id: child.id } }

    it "should remove the child", :aggregate_failures do
      expect { subject }.to change(Child, :count).by(-1)
    end
  end
end
