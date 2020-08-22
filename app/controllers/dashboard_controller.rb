# Prepares data to be shown to the users for their dashboard.
class DashboardController < ApplicationController
  respond_to :html, :js

  def index
    @partner = current_partner
    @partner_requests = current_partner.partner_requests
                                       .order(created_at: :desc)
                                       .limit(10)
    @families = current_partner.families
    @children = current_partner.children
  end
end
