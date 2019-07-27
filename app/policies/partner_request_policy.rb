# Authorization for limited CRUD actions on Partner Requests using Pundit
#
# Pundit relies on current_user
#   see `pundit_user` method in partner_requests_controller
#
# Partners can only view and create their own records.
class PartnerRequestPolicy < ApplicationPolicy
  def index?
    true
  end

  def create?
    record.partner == user.partner
  end

  def show?
    record.partner == user.partner
  end
end
