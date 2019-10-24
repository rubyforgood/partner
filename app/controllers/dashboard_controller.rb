# Prepares data to be shown to the users for their dashboard.
class DashboardController < ApplicationController
  respond_to :html, :js

  def index
    @partner = current_partner

    # Change the variable below to reflect on the Diaper Request History dashboard table
    @no_requests = 10
    @partner_requests = current_partner.partner_requests.most_recent(@no_requests)

    @families = current_partner.families
    @children = current_partner.children
  end
end
