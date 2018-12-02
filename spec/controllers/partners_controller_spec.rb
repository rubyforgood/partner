require "rails_helper"

describe PartnersController, type: :controller do
  context "when authenticated" do
    login_partner

    describe "GET #new" do
      it "returns http success" do
        get :new
        expect(response).to have_http_status(200)
      end
    end

    describe "GET #show" do
      it "returns http success" do
        get :show, params: { id: @partner.id }
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
          post :create, params: { partner: attributes_for(:partner) }
        end.to change(Partner, :count).by(0)
      end
    end
  end

  context "when not authenticated" do
    let(:partner) { create(:partner) }

    describe "GET #new" do
      subject { get :new }

      it_behaves_like "user is not logged in"
    end

    describe "GET #show" do
      subject { get :show, params: { id: partner.id } }

      it_behaves_like "user is not logged in"
    end

    describe "Get #approve" do
      subject { get :approve, params: { partner_id: partner.id } }

      it_behaves_like "user is not logged in"
    end

    describe "Post #create" do
      subject { post :create, params: { partner: attributes_for(:partner) } }

      it_behaves_like "user is not logged in"

      it "does not create a new partner" do
        expect { subject }.to_not change(Partner, :count)
      end
    end
  end
end

