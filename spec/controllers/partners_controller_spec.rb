require "rails_helper"

describe PartnersController, type: :controller, include_shared: true do
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
        stub_partner_requst
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

    describe "Post #index" do
      it "does not allow access to partner" do
        get :index
        expect(response).to have_http_status(:redirect)
      end
    end

    describe "PATCH #update" do
      subject { patch :update, params: { id: @partner.id, partner: { name: "updated name" } } }

      it "updates the partner" do
        expect { subject }.to change { @partner.reload.name }.to("updated name")
      end

      it "redirects to #show" do
        expect(subject.request).to redirect_to(@partner)
        expect(subject.request.flash[:notice]).to eq("Details were successfully updated.")
      end
    end

    describe "GET #edit" do
      it "displays the partner form" do
        get :edit, params: { id: @partner.id }
        expect(response).to have_http_status(200)
      end
    end

    describe "DELETE #destroy" do
      subject { delete :destroy, params: { id: @partner.id } }
      it "redirects the user" do
        expect(subject.request).to redirect_to(root_path)
      end

      it "does not delete partner" do
        expect { subject }.to change(Partner, :count).by(0)
        expect(subject.request.flash[:notice]).to eq("You are not authorized to perform this action.")
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

    describe "GET #index" do
      subject { get :index }
      it_behaves_like "user is not logged in"
    end

    describe "GET #edit" do
      subject { get :edit, params: { id: partner.id } }
      it_behaves_like "user is not logged in"
    end

    describe "PATCH #update" do
      subject { patch :update, params: { id: partner.id, partner: { name: "updated name" } } }
      it_behaves_like "user is not logged in"
      it "does not save the partner" do
        expect { subject }.not_to(change { partner.reload.name })
      end
    end

    describe "DELETE #destroy" do
      let!(:partner) { create(:partner) }
      subject { delete :destroy, params: { id: partner.id } }
      it_behaves_like "user is not logged in"
      it "does not delete partner" do
        expect { subject }.not_to change(Partner, :count)
        expect(subject.request.flash[:notice]).to eq("You are not authorized to perform this action.")
      end
    end
  end

  def stub_partner_requst
    stub_request(:post, diaperbank_routes.partner_approvals).with(
      body: {partner: {diaper_partner_id: @partner.id}}.to_json,
      headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'Content-Type'=>'application/json',
        'Host'=> diaperbank_routes.partner_approvals.host,
        'User-Agent'=>'Ruby',
        'X-Api-Key'=>ENV["DIAPERBANK_KEY"]
      }
    ).to_return(status: 200, body: "", headers: {})
  end
end
