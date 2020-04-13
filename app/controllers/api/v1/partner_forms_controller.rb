class Api::V1::PartnerFormsController < ApiController
  skip_before_action :verify_authenticity_token
  respond_to :json

  def create
    return head :forbidden unless api_key_valid?

    partner_form = PartnerForm.where(
      diaper_bank_id: partner_form_params[:diaper_bank_id],
    ).first_or_create

    partner_form.update(sections: partner_form_params[:sections])

    render json: {
      partner_form: partner_form
    }
  rescue ActiveRecord::RecordInvalid => e
    render e.message
  end

  private

  def api_key_valid?
    return true if Rails.env.development?

    request.headers["X-Api-Key"] == ENV["DIAPER_KEY"]
  end

  def partner_form_params
    params.require(:partner_form).permit(
      :diaper_bank_id,
      sections: []
    )
  end
end
