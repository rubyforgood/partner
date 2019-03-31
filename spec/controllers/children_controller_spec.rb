require "rails_helper"

# This controller is _probably_ no longer necessary - delete it before merging
# the families branch
RSpec.xdescribe ChildrenController, type: :controller do
  let(:family) { create(:family, partner: create(:partner)) }
  let(:valid_attributes) { attributes_for(:child, family: family) }

  let(:invalid_attributes) do
    skip("Add a hash of attributes invalid for your model")
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ChildrenController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  context "when authenticated" do
    login_partner
    describe "GET #index" do
      it "returns a success response" do
        Child.create! valid_attributes
        get :index, params: {}, session: valid_session
        expect(response).to be_successful
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        child = Child.create! valid_attributes
        get :show, params: { id: child.to_param }, session: valid_session
        expect(response).to be_successful
      end
    end

    describe "GET #new" do
      it "returns a success response" do
        get :new, params: {}, session: valid_session
        expect(response).to be_successful
      end
    end

    describe "GET #edit" do
      it "returns a success response" do
        child = Child.create! valid_attributes
        get :edit, params: { id: child.to_param }, session: valid_session
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Child" do
          expect do
            post :create, params: { child: valid_attributes }, session: valid_session
          end.to change(Child, :count).by(1)
        end

        it "redirects to the created child" do
          post :create, params: { child: valid_attributes }, session: valid_session
          expect(response).to redirect_to(Child.last)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { child: invalid_attributes }, session: valid_session
          expect(response).to be_successful
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) do
          skip("Add a hash of attributes valid for your model")
        end

        it "updates the requested child" do
          child = Child.create! valid_attributes
          put :update, params: { id: child.to_param, child: new_attributes }, session: valid_session
          child.reload
          skip("Add assertions for updated state")
        end

        it "redirects to the child" do
          child = Child.create! valid_attributes
          put :update, params: { id: child.to_param, child: valid_attributes }, session: valid_session
          expect(response).to redirect_to(child)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          child = Child.create! valid_attributes
          put :update, params: { id: child.to_param, child: invalid_attributes }, session: valid_session
          expect(response).to be_successful
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested child" do
        child = Child.create! valid_attributes
        expect do
          delete :destroy, params: { id: child.to_param }, session: valid_session
        end.to change(Child, :count).by(-1)
      end

      it "redirects to the children list" do
        child = Child.create! valid_attributes
        delete :destroy, params: { id: child.to_param }, session: valid_session
        expect(response).to redirect_to(children_url)
      end
    end
  end

  context "when not authenticated" do
    describe "GET #new" do
      subject { get :new }

      it_behaves_like "user is not logged in"
    end

    describe "POST #create" do
      it "does not create a new child" do
        expect do
          post :create, params: { child: valid_attributes }
        end.to_not change(Child, :count)
      end
    end

    describe "GET #show" do
      subject { get :show, params: { id: child.id } }
      let(:child) { create(:child) }

      it_behaves_like "user is not logged in"
    end

    describe "GET #index" do
      subject { get :index }
      it_behaves_like "user is not logged in"
    end
  end
end
