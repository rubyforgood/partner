require "rails_helper"

RSpec.describe "Children", type: :request do
  let(:partner) { create(:partner) }
  let(:family) { create(:family, partner_id: partner.id) }

  before do
    user = create(:user, partner: partner)
    sign_in(user)
  end

  describe "POST #create" do
    it "should create and redirect to child_path" do
      post children_path, params: { family_id: family.id, child: attributes_for(:child) }

      select_child = Child.select(:id).last
      expect(response).to redirect_to(child_path(select_child.id))
      expect(request.flash[:notice]).to eql "Child was successfully created."
    end
  end

  let(:child) { create(:child, family_id: family.id) }

  describe "PUT #update" do
    it "should update and redirect to child_path" do
      put child_path(child), params: { child: attributes_for(:child) }

      expect(response).to redirect_to(child_path(child.id))
      expect(request.flash[:notice]).to eql "Child was successfully updated."
    end
  end

  describe "POST #active" do
    it "should verify if child is active" do
      post child_active_path(child), params: { child_id: child.id }

      expect(child.active).to eq true
    end
  end
end

