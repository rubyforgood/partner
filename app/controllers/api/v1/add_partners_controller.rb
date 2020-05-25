class Api::V1::AddPartnersController < ApiController
  skip_before_action :verify_authenticity_token
  respond_to :json

  def create
    return head :forbidden unless api_key_valid?

    partner = Partner.find_by(diaper_partner_id: partner_params[:diaper_partner_id])

    user = User.find_by(email: partner_params[:email])
    if user
      user.send_reset_password_instructions
    else
      user = User.invite!(email: partner_params[:email], partner: partner) do |new_user|
        new_user.message = partner_params[:invitation_text]
        new_user.invitation_reply_to = partner_params[:organization_email]
      end
    end

    render json: {
      email: user.email,
      id: partner.id
    }
  rescue ActiveRecord::RecordInvalid => e
    render e.message
  end

  private

  def api_key_valid?
    return true if Rails.env.development?

    request.headers["X-Api-Key"] == ENV["DIAPER_KEY"]
  end

  def partner_params
    params.require(:partner).permit(
      :diaper_partner_id,
      :invitation_text,
      :organization_email,
      :email
    )
  end
end
