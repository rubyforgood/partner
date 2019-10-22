class PickupSheetsController < ApplicationController
  before_action :authenticate_user!

  helper_method :partner_request, :child_item_requests

  def show
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "Your_filename",
        template: "pickup_sheets/pdf_show.html.erb",
        layout: "pdf.html"
      end
    end
  end

  private

  def partner_request
    @partner_request ||= current_partner.partner_requests.includes(item_requests: :children).find(params[:family_request_id])
  end

  def child_item_requests
    @child_item_requests ||= partner_request.item_requests.map(&:child_item_requests).flatten.sort_by do |child_item_request|
      child_item_request.child.display_name
    end
  end
end
