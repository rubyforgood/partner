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
    flash[:notice] = "Created!  TODO: actually send the request"
    # TODO: send a request to the diaper bank
    redirect_to action: :new
  end

  private

  def family_request_params
    params.require(:family_request).slice(
      :child_ids
    )
  end
end
