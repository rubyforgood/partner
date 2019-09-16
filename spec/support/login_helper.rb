module LoginHelper
  def login_user(options ={})
    before(:each) do
      @partner = create(:partner, options)
      @user = create(:user, partner: @partner)
      sign_in @user
    end
  end
end
