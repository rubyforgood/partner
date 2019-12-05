require "rails_helper"

RSpec.describe "Authorized Family Members Controller", type: :request do
  let(:partner) { create(:partner) }
  let(:user) { create(:user, partner: partner) }
  let!(:family) { create(:family, partner: partner) }

  before do
    sign_in(user)
  end

  describe "GET #new" do
    it "returns http status ok" do
      get new_authorized_family_member_path

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    let!(:authorized_family_member) { create(:authorized_family_member, family: family) }

    it "returns http status ok" do
      get authorized_family_member_path(authorized_family_member)

      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST #create" do
    let(:authorized_family_member_params) { attributes_for(:authorized_family_member) }

    it "creates and redirects to authorized_family_member_path" do
      post authorized_family_members_path, params: {
        authorized_family_member: authorized_family_member_params
      }

      member = AuthorizedFamilyMember.last

      expect(response).to redirect_to(authorized_family_member_path(member))
      expect(request.flash[:notice]).to eql "Authorized member was successfully created."
    end
  end

  describe "PUT #update" do
    let!(:authorized_family_member) { create(:authorized_family_member, family: family) }

    it "updates and redirects to authorized_family_member_path" do
      put authorized_family_member_path(authorized_family_member), params: {
        authorized_family_member: attributes_for(:authorized_family_member)
      }

      expect(response).to redirect_to(authorized_family_member_path(authorized_family_member))
      expect(request.flash[:notice]).to eql "Authorized family member was successfully updated."
    end
  end
end
