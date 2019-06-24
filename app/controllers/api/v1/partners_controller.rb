class Api::V1::PartnersController < ApiController
  skip_before_action :verify_authenticity_token
  respond_to :json

  def create
    return head :forbidden unless api_key_valid?

    partner = Partner.invite!(email: partner_params[:email],
      diaper_bank_id: partner_params[:diaper_bank_id],
      diaper_partner_id: partner_params[:diaper_partner_id])

    render json: partner.to_json(
      only: [:id, :email]
    )
  rescue ActiveRecord::RecordInvalid => e
    render e.message
  end

  def update
    return head :forbidden unless api_key_valid?

    partner = Partner.find_by(diaper_partner_id: partner_params[:diaper_partner_id])
    if partner_params[:status] == "pending"
      partner.update(partner_status: "pending")
    elsif partner_params[:status] == "recertification_required"
      partner.update(partner_status: "Recertification Required")
    elsif partner_params[:status] == "approved"
      partner.update(partner_status: "Verified")
    else
      partner.update(partner_status: "pending")
    end
    render json: { message: "Partner status changed to verified." }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
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
      :email,
      :status
    )
  end
end
