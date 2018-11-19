require "rails_helper"

RSpec.describe PartnersController, type: :controller do
  login_partner

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(200)
    end
  end

  describe "Get #approve" do
    it "should redirect to partner" do
      @partner = create(:partner)
      get :approve, params: { partner_id: @partner.id }
      expect(response).to redirect_to(@partner)
    end
  end

  describe "Post #create" do
    it "creates a new partner" do
      expect do
        print(FactoryBot.attributes_for(:partner))
        post :create, params: { partner: FactoryBot.attributes_for(:partner) }
      end.to change(Partner, :count).by(0)
    end
  end
end

