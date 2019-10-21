class ChildItemRequestsController < ApplicationController
  before_action :authenticate_user!

  def toggle_picked_up
    child_item_request.toggle!(:picked_up)
    respond_to do |format|
      format.js do
        action = child_item_request.picked_up ? "complete" : "not_complete"
        message = t(
          "child_item_requests.pickup.#{action}",
          child_name: child_item_request.child.first_name
        )
        render partial: "child_item_requests/child_item_request_update",
          object: build_open_struct(message)
      end
    end
  end

  def quantity_picked_up
    child_item_request.update(quantity_picked_up: params[:quantity_picked_up])
    respond_to do |format|
      format.js do
        message = t(
          "child_item_requests.quantity_picked_up",
          child_name: child_item_request.child.first_name,
          quantity_ordered: child_item_request.quantity,
          quantity_picked_up: params[:quantity_picked_up]
        )
        render partial: "child_item_requests/child_item_request_update",
          object: build_open_struct(message)
      end
    end
  end

  def item_picked_up
    child_item_request.update(
      picked_up_item_diaperid: params[:picked_up_item_diaperid]
    )
    respond_to do |format|
      format.js do
        message = t(
          "child_item_requests.item_picked_up",
          child_name: child_item_request.child.first_name,
          item_ordered: item_id_to_display_string_map[
            child_item_request.child.item_needed_diaperid
          ],
          item_picked_up_label: item_id_to_display_string_map[
            child_item_request.picked_up_item_diaperid
          ],
        )
        render partial: "child_item_requests/child_item_request_update",
          object: build_open_struct(message)
      end
    end

  end

  private

  def build_open_struct(message)
    OpenStruct.new(message: message, item_id: child_item_request.id)
  end

  def child_item_request
    @child_item_request ||= ChildItemRequest.find(params[:id]).tap do |item|
      current_partner.children.pluck(:id).include?(item.child_id) ? item : nil
    end
  end
end
