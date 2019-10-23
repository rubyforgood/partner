class Users::InvitationsController < Devise::InvitationsController
  layout "application"

  def create
    user = User.invite!(
      email: user_params[:email],
      name: user_params[:name],
      partner: current_partner,
    )
    flash[:success] = "You have invited #{user.name} to join your organization!"
    redirect_to users_path
  end

  def new
    @user = current_partner.users.new
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
