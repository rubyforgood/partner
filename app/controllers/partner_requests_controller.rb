class PartnerRequestsController < ApplicationController
  before_action :authenticate_partner!

  def new
    @partner_request = PartnerRequest.new
    @partner_request.items.build # required to render the empty items form
  end

  def create
    @partner_request = PartnerRequest.new(partner_request_params.merge(partner_id: current_partner.id))

    respond_to do |format|
      if @partner_request.save
        # NOTE(chaserx): send request to diaper app.
        if DiaperBankClient.request_submission_post(@partner_request.id)
          @partner_request.update_columns(sent: true)
        else
          @partner_request.errors.add(:base, :sending_failure, message: "request saved but failed to send")
        end
        format.html { redirect_to partner_request_thanks_path(@partner_request), notice: "Request was successfully created." }
      else
        format.html { render :new }
      end
    end
  end

  def thanks
    @partner_request = PartnerRequest.find(params[:partner_request_id])
  end

  private

  def partner_request_params
    params.require(:partner_request).permit(:comments, items_attributes: Item.attribute_names.map(&:to_sym).push(:_destroy))
  end
end
