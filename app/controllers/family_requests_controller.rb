class FamilyRequestsController < ApplicationController
  before_action :authenticate_partner!

  def new
    @family_request = current_partner.family_requests.new
    @children = current_partner.children
  end

  def create
    create_params = family_request_params
    children = Child.find(create_params.delete(:child_ids))
    @family_request = current_partner.family_requests.new(children: children)
    if @family_request.save
      if api_response = DiaperBankClient.send_family_request(@family_request.id)
        @family_request.update!(sent: true)
        flash[:notice] = "Request sent to diaper bank successfully"
        partner_request = PartnerRequest.new(api_response.slice("partner_id", "organization_id"))
        api_response["requested_items"].each do |item_hash|
          partner_request.item_requests.new(
            name: POSSIBLE_ITEMS.key(item_hash["item_name"]),
            item_id: item_hash["item_id"],
            quantity: item_hash["count"]
          )
        end
        partner_request.save!
      else
        @family_request.errors.add(:base, :sending_failure, message: "Your request saved but failed to send")
      end
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
