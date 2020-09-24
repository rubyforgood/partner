class FamilyRequestsController < ApplicationController
  before_action :authenticate_user!

  def new
    verify_status_in_diaper_base
    @filterrific = initialize_filterrific(
      current_partner.children
          .order(last_name: :asc)
          .order(first_name: :asc),
      params[:filterrific]
    ) || return
    @children = @filterrific.find
  end

  def create
    verify_status_in_diaper_base
    children = current_partner.children.active.where.not(item_needed_diaperid: nil)
    children_grouped_by_diaperid = children.group_by(&:item_needed_diaperid)
    payload = FamilyRequestPayloadService.execute(children: children, partner: current_partner)
    api_response = DiaperBankClient.send_family_request(payload)

    if api_response
      flash[:notice] = "Request sent to diaper bank successfully"
      partner_request = PartnerRequest.new(
        api_response
        .slice("organization_id")
        .merge(partner_id: current_partner.id, sent: true, for_families: true)
      )
      api_response["requested_items"].each do |item_hash|
        partner_request.item_requests.new(
          name: item_hash["item_name"],
          item_id: item_hash["item_id"],
          quantity: item_hash["count"],
        ).tap do |item_request|
          item_request.children =
            children_grouped_by_diaperid[item_hash["item_id"]].to_a
        end
      end
      partner_request.save!
      redirect_to partner_requests_path
    else
      render :new
    end
  end

  private

  def family_request_params
    params.require(:family_request).slice(
      :child_ids
    )
  end
end
