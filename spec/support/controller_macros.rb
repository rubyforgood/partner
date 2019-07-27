module ControllerMacros
  def login_user(options = {})
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @partner = create(:partner, options)
      @user = create(:user, partner: @partner)
      sign_in @user
    end
  end
end
