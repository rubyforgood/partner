module ControllerMacros
  def login_partner(options = {})
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:partner]
      @partner = create(:partner, options)
      sign_in @partner
    end
  end
end
