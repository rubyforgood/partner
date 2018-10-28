class PartnerRequestsController < ApplicationController
  def new
    @partner_request = PartnerRequest.new
    @partner_request.items.build
  end

  def create
    @partner_request = PartnerRequest.new(partner_request_params)

    respond_to do |format|
      if @partner_request.save
        format.html { redirect_to partner_request_thanks_path(@partner_request), notice: "partner_request was successfully created." }
        format.json { render :thanks, status: :created, location: @partner_request }
      else
        format.html { render :new }
        format.json { render json: @partner_request.errors, status: :unprocessable_entity }
      end
    end
  end

  def thanks; end

  private

  def partner_request_params
    params.require(:partner_request).permit(:comments, items_attributes: Item.attribute_names.map(&:to_sym).push(:_destroy))
  end
end
