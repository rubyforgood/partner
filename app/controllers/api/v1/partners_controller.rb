class Api::V1::PartnersController < ApiController
  skip_before_action :verify_authenticity_token
  respond_to :json

  def create
    return head :forbidden unless api_key_valid?

    partner = Partner.new(
      diaper_bank_id: partner_params[:diaper_bank_id],
      diaper_partner_id: partner_params[:diaper_partner_id]
    )

    user = User.invite!(email: partner_params[:email], partner: partner) do |new_user|
      new_user.message = partner_params[:invitation_text]
    end

    render json: {
      email: user.email,
             id: partner.id
    }
  rescue ActiveRecord::RecordInvalid => e
    render e.message
  end

  def update
    return head :forbidden unless api_key_valid?

    partner = Partner.find_by!(diaper_partner_id: partner_params[:diaper_partner_id])
    if partner_params[:status] == "pending"
      partner.update(partner_status: "pending")
    elsif partner_params[:status] == "recertification_required"
      partner.update(partner_status: "recertification_required")
      RecertificationMailer.with(partner: partner).notice_email.deliver_now
    elsif partner_params[:status] == "approved"
      partner.update(partner_status: "verified")
    else
      partner.update(partner_status: "pending")
    end

    render json: { message: "Partner status: #{partner.partner_status}." }, status: :ok
  rescue ActiveRecord::RecordNotFound => e
    render e.message
  end

  def show
    return head :forbidden unless api_key_valid?

    partner = Partner.find_by(diaper_partner_id: params[:id])

    render json: { agency: partner.export_json }
  end

  private

  def api_key_valid?
    return true if Rails.env.development?

    request.headers["X-Api-Key"] == ENV["DIAPER_KEY"]
  end

  def partner_params
    params.require(:partner).permit(
      :diaper_bank_id,
      :diaper_partner_id,
      :invitation_text,
      :email,
      :status
    )
  end
end
