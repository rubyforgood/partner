require "rails_helper"

RSpec.describe FamiliesController, type: :controller do
  # This should return the minimal set of attributes required to create a valid
  # Family. As you add validations to Family, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) do
    {
      guardian_first_name: "Star",
      guardian_last_name: "Lord"
    }
  end

  let(:invalid_attributes) do
    skip("Add a hash of attributes invalid for your model")
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # FamiliesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  context "when authenticated" do
    login_partner
    describe "GET #index" do
      it "returns a success response" do
        Family.create! valid_attributes
        get :index, params: {}, session: valid_session
        expect(response).to be_successful
      end
    end

    describe "GET #show" do
      it "returns a success response" do
        family = Family.create! valid_attributes
        get :show, params: { id: family.to_param }, session: valid_session
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
        family = Family.create! valid_attributes
        get :edit, params: { id: family.to_param }, session: valid_session
        expect(response).to be_successful
      end
    end

    describe "POST #create" do
      context "with valid params" do
        it "creates a new Family" do
          expect do
            post :create, params: { family: valid_attributes }, session: valid_session
          end.to change(Family, :count).by(1)
        end

        it "redirects to the created family" do
          post :create, params: { family: valid_attributes }, session: valid_session
          expect(response).to redirect_to(Family.last)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'new' template)" do
          post :create, params: { family: invalid_attributes }, session: valid_session
          expect(response).to be_successful
        end
      end
    end

    describe "PUT #update" do
      context "with valid params" do
        let(:new_attributes) do
          skip("Add a hash of attributes valid for your model")
        end

        it "updates the requested family" do
          family = Family.create! valid_attributes
          put :update, params: { id: family.to_param, family: new_attributes }, session: valid_session
          family.reload
          skip("Add assertions for updated state")
        end

        it "redirects to the family" do
          family = Family.create! valid_attributes
          put :update, params: { id: family.to_param, family: valid_attributes }, session: valid_session
          expect(response).to redirect_to(family)
        end
      end

      context "with invalid params" do
        it "returns a success response (i.e. to display the 'edit' template)" do
          family = Family.create! valid_attributes
          put :update, params: { id: family.to_param, family: invalid_attributes }, session: valid_session
          expect(response).to be_successful
        end
      end
    end

    describe "DELETE #destroy" do
      it "destroys the requested family" do
        family = Family.create! valid_attributes
        expect do
          delete :destroy, params: { id: family.to_param }, session: valid_session
        end.to change(Family, :count).by(-1)
      end

      it "redirects to the families list" do
        family = Family.create! valid_attributes
        delete :destroy, params: { id: family.to_param }, session: valid_session
        expect(response).to redirect_to(families_url)
      end
    end
  end

  context "when not authenticated" do
    describe "GET #new" do
      subject { get :new }

      it_behaves_like "user is not logged in"
    end

    describe "POST #create" do
      it "does not create a new family" do
        expect do
          post :create, params: { family: valid_attributes }
        end.to_not change(Family, :count)
      end
    end

    describe "GET #show" do
      subject { get :show, params: { id: family.id } }
      let(:family) { create(:family) }

      it_behaves_like "user is not logged in"
    end

    describe "GET #index" do
      subject { get :index }
      it_behaves_like "user is not logged in"
    end
  end
end
