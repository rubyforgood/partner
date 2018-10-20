class Api::V1::PartnersController < ApiController
  skip_before_action :verify_authenticity_token
  respond_to :json

  def create
    return head :forbidden unless api_key_valid?
    partner = Partner.invite!(email: create_params[:email],
      diaper_bank_id: create_params[:diaper_bank_id],
      diaper_partner_id: create_params[:diaper_partner_id]
    )

    render json: partner.to_json(
      only: [:id, :email]
    )
  rescue ActiveRecord::RecordInvalid => e
    render e.message
  end


  private

  def api_key_valid?
    request.headers["X-Api-Key"] == ENV["DIAPER_KEY"]
  end

  def create_params
    params.require(:partner).permit(
      :diaper_bank_id,
      :diaper_partner_id,
      :email
    )
  end
end
