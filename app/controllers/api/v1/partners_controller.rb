class Api::V1::PartnersController < ApiController
  def create
    partner_service = PartnerService.new
    partner = partner_service.create(create_params)

    render json: partner.to_json(
      only: [:id, :email]
    )
  rescue ActiveRecord::RecordInvalid => e
    render e.message
  end

  def index
    partners = Partner.all
    render json: partners.to_json(
      only: [:diaper_partner_id, :name]
    )
  end

  private

  def create_params
    params.permit(
      :diaper_bank_id,
      :diaper_partner_id,
      :email
    )
  end
end
