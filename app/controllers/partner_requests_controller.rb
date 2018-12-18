class PartnerRequestsController < ApplicationController
  before_action :authenticate_partner!

  def index
    @partner = current_partner
    @partner_requests = current_partner.partner_requests.order(created_at: :desc) # PartnerRequest.where(partner_id: current_partner.id)
  end

  def new
    @partner_request = PartnerRequest.new
    @valid_items = DiaperBankClient.get_available_items(current_partner.diaper_bank_id)
    @partner_request.items.build # required to render the empty items form
  end

  def create
    @partner_request = PartnerRequest.new(partner_request_params.merge(partner_id: current_partner.id))

    respond_to do |format|
      if @partner_request.save
        # NOTE(chaserx): send request to diaper app.
        if DiaperBankClient.request_submission_post(@partner_request.id)
          @partner_request.update(sent: true)
        else
          @partner_request.errors.add(:base, :sending_failure, message: "Your request saved but failed to send")
        end
        format.html { redirect_to partner_requests_path, notice: "Request was successfully created." }
      else
        format.html { render :new }
      end
    end
  end

  def show
    @partner_request = PartnerRequest.find(params[:id])
    authorize @partner_request
  end

  private

  def partner_request_params
    params.require(:partner_request).permit(:comments, items_attributes: Item.attribute_names.map(&:to_sym).push(:_destroy))
  end

  # NOTE(chaserx): the is required for pundit since our auth'd user is named `partner`
  def pundit_user
    current_partner
  end
end
