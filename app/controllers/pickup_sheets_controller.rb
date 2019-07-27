class PickupSheetsController < ApplicationController
  before_action :authenticate_partner!

  helper_method :family_request

  def show;end

  private

  def family_request
    @family_request ||= current_partner.family_requests
      .find(params[:family_request_id])
  end
end
