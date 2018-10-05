class PartnerService
  def create(params)
    partner = Partner.new(
      diaper_bank_id: params[:diaper_bank_id],
      diaper_partner_id: params[:diaper_partner_id],
      email: params[:email]
    )

    # TODO: Validation should not be skipped. Password should not be required when first creating a user
    partner.save!(validate: false)
  end
end