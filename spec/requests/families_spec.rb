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

  describe "GET #show" do
    let(:family) { create(:family, partner: partner) }

    it "should return status code 200 if a family is found" do
      get family_path(family.id)

      expect(response).to have_http_status :ok
    end

    it "should render 404 for a family not found" do
      max_id = family.id + 1

      get family_path(max_id)

      expect(response).to have_http_status :not_found
    end
  end

  describe "GET #edit" do
    let(:family) { create(:family, partner: partner) }

    it "should render the edit template" do
      get edit_family_path(family.id)

      expect(response).to render_template(:edit)
    end

    it "should render 404 for a family not found" do
      max_id = family.id + 1

      get edit_family_path(max_id)

      expect(response).to have_http_status :not_found
    end
  end

  describe "POST #create" do
    it "should create and redirect to family_path" do
      post families_path, params: { family: attributes_for(:family) }

      family = Family.select(:id).last

      expect(response).to redirect_to(family_path(family.id))
      expect(request.flash[:notice]).to eql "Family was successfully created."
    end

    it "renders :new if the create action does not succeed" do
      post families_path, params: { family:  { guardian_first_name: nil } }

      family = Family.last

      expect(response).to render_template(:new)
      expect(family).to be_nil
    end
  end

  describe "PUT #update" do
    let(:family) { create(:family, partner: partner) }

    it "should update  and redirect to family_path" do
      put family_path(family), params: { family: attributes_for(:family) }

      expect(response).to redirect_to(family_path(family.id))
      expect(request.flash[:notice]).to eql "Family was successfully updated."
    end

    it "renders :edit if the update does not succeed" do
      put family_path(family), params: { family: { guardian_first_name: nil } }

      expect(response).to have_http_status :ok
      expect(response).to render_template(:edit)
      expect(family.guardian_first_name).not_to be_nil
    end
  end

  describe "DELETE #destroy" do
    let(:family) { create(:family, partner: partner) }

    it "should destroy   and redirect to families_path" do
      delete family_path(family)

      expect(response).to redirect_to(families_path)
      expect(request.flash[:notice]).to eql "Family was successfully destroyed."
    end
  end
end
