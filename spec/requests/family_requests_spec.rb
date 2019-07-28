require "rails_helper"

RSpec.describe "FamilyRequests", type: :request do
  describe "GET /new" do
    let(:partner) { create(:partner, :verified) }

    it 'renders the new template' do
      sign_in partner
      get "/family_requests/new"
      expect(response).to render_template(:new)
    end
  end
end
