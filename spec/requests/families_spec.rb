require "rails_helper"

RSpec.describe "Families", type: :request do
  let(:partner) { create(:partner) }
  let!(:user) { create(:user, partner: partner) }

  before do
    sign_in(user)
  end

  describe "GET #index" do
    it "return http sucess" do
      get families_path 

      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #new" do
    it "should return status code 200" do 
      get new_family_path

      expect(response).to have_http_status :ok
    end
  end

  describe "POST #create" do    
    it "should create and redirect to family_path" do 
      post families_path, params: { family: attributes_for(:family) }

      family = Family.select(:id).last

      expect(response).to redirect_to(family_path(family.id))
      expect(request.flash[:notice]).to eql  "Family was successfully created."
    end
  end

  describe "PUT #update" do
    let(:family) { create(:family, partner: partner) }  

    it "should update  and redirect to family_path" do
      put family_path(family), params: { family: attributes_for(:family) }

      expect(response).to redirect_to(family_path(family.id))
      expect(request.flash[:notice]).to eql  "Family was successfully updated."
    end
  end

  describe "DELETE #destroy" do
    let(:family) { create(:family, partner: partner) }

    it "should destroy   and redirect to families_path" do
      delete family_path(family)

      expect(response).to redirect_to(families_path)
      expect(request.flash[:notice]).to eql  "Family was successfully destroyed."
    end
  end
end
