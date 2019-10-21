class ChildItemRequestsController < ApplicationController
  before_action :authenticate_user!

  def toggle_picked_up
    child_item_request = ChildItemRequest.find(params[:id]).tap do |item|
      current_partner.children.pluck(:id).include?(item.child_id) ? item : nil
    end
    child_item_request.toggle!(:picked_up)
    respond_to do |format|
      format.js do
        action = child_item_request.picked_up ? "complete" : "not_complete"
        message = t(
          "child_item_requests.pickup.#{action}",
          child_name: child_item_request.child.first_name
        )
        render partial: "child_item_requests/child_item_request_update",
          object: OpenStruct.new(message: message)
      end
    end
  end
end
