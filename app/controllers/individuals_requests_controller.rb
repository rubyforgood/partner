class IndividualsRequestsController < ApplicationController
  helper MultiItemFormHelper

  before_action :authenticate_user!
  before_action :verify_status_in_diaper_base
  before_action :authorize_verified_partners

  def new; end
end
