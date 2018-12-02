module ControllerMacros
  def login_partner
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:partner]
      @partner = create(:partner)
      sign_in @partner
    end
  end
end
