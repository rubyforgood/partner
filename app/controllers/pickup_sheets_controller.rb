class PickupSheetsController < ApplicationController
  before_action :authenticate_partner!

  helper_method :partner_request, :child_item_requests

  def show; end

  private

  def partner_request
    @partner_request ||= current_partner.partner_requests.includes(item_requests: :children).find(params[:family_request_id])
  end

  def child_item_requests
    @child_item_requests ||= partner_request.item_requests.map do |item_request|
      item_request.child_item_requests
    end.flatten.sort_by do |child_item_request|
      child_item_request.child.display_name
    end
  end
end
