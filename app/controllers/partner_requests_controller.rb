class PartnerRequestsController < ApplicationController
  before_action :authenticate_partner!

  def index
    @partner = current_partner
    @partner_requests = current_partner.partner_requests.order(created_at: :desc) # PartnerRequest.where(partner_id: current_partner.id)
  end

  def new
    if current_partner.partner_status == "Approved"
      @partner_request = PartnerRequest.new
      @valid_items = DiaperBankClient.get_available_items(current_partner.diaper_bank_id)
      @valid_items = @valid_items.map { |item| [item["name"], item["id"]] }
      @partner_request.item_requests.build # required to render the empty items form
    else
      redirect_to partner_requests_path, notice: "Please review your application details and submit for approval in order to make a new request."
    end
  end

  def create
    @partner_request = PartnerRequest.new(partner_request_params.merge(partner_id: current_partner.id))
    @partner_request.item_requests << create_item_requests
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
    params.require(:partner_request).permit(:comments, :item_requests_attributes)
  end

  def get_full_item_values(id)
    valid_items = DiaperBankClient.get_available_items(current_partner.diaper_bank_id)
    valid_items.find { |item| item["id"] == id.to_i }
  end

  def create_item_requests
    item_params = params.dig("partner_request", "item_requests_attributes")&.values
    item_params.map do |item|
      full_item = get_full_item_values(item["item_id"])
      ItemRequest.new(
        item_id: item["item_id"],
        quantity: item["quantity"],
        name: full_item["name"],
        partner_key: full_item["partner_key"]
      )
    end
  end

  # NOTE(chaserx): the is required for pundit since our auth'd user is named `partner`
  def pundit_user
    current_partner
  end
end
