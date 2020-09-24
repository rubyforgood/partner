class IndividualsRequestsController < ApplicationController
  helper MultiItemFormHelper

  before_action :authenticate_user!
  before_action :verify_status_in_diaper_base
  before_action :authorize_verified_partners

  def new
    @request = FamilyRequest.new({}, initial_items: 1)
  end

  def create
    @request = FamilyRequest.new(family_request_params, partner: current_partner)

    FamilyRequestService.execute(@request)

    redirect_to partner_requests_path, notice: "Requested items successfuly!"
  rescue ActiveModel::ValidationError
    render :new
  end

private

  def family_request_params
    params.require(:family_request)
          .permit(:comments, items_attributes: %i[item_id people_count])
  end
end
