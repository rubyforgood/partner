# Authorization for CRUD actions on Partner using Pundit
#
# Pundit relies on current_user
#   see `pundit_user` method in partners_controller
#
# Partners can only affect their own records.
# Later may want to admins authorization.
class PartnerPolicy < ApplicationPolicy
  def create?
    true
  end

  def show?
    user&.partner == record
  end

  def update?
    user&.partner == record
  end

  # TODO(chaserx): I think we should prevent deletion until we add a soft delete
  def destroy?
    false
  end
end
