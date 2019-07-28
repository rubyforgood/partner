class PartnersController < ApplicationController
  before_action :set_partner, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_partner!

  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found_response

  def index
    @partners = Partner.all
    authorize @partners
  end

  def show; end

  def new
    @partner = Partner.new
  end

  def edit; end

  def approve
    @partner = Partner.find(params[:partner_id])
    @partner.approve_me
    redirect_to @partner, notice: "You have submitted your details for approval."
  end

  def create
    @partner = Partner.new(partner_params)

    respond_to do |format|
      @partner.save
      format.html { redirect_to @partner, notice: "Partner was successfully created." }
      format.json { render :show, status: :created, location: @partner }
    end
  end

  def update
    respond_to do |format|
      @partner.update(partner_params)
      format.html { redirect_to @partner, notice: "Details were successfully updated." }
      format.json { render :show, status: :ok, location: @partner }
    end
  end

  def destroy
    @partner.destroy
    redirect_to partners_url, notice: "Partner was successfully destroyed."
  end

  private

  def render_unprocessable_entity_response(exception)
    render json: exception.record.errors, status: :unprocessable_entity
  end

  def render_not_found_response(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def set_partner
    @partner = authorize Partner.find(params[:id])
  end

  def partner_params
    params.require(:partner).permit(
      :name,
      :agency_type,
      :other_agency_type,
      :partner_status,
      :proof_of_partner_status,
      :agency_mission,
      :address1,
      :address2,
      :city,
      :state,
      :zip_code,
      :website,
      :facebook,
      :twitter,
      :founded,
      :form_990,
      :proof_of_form_990,
      :program_name,
      :program_description,
      :program_age,
      :case_management,
      :evidence_based,
      :evidence_based_description,
      :program_client_improvement,
      :diaper_use,
      :other_diaper_use,
      :currently_provide_diapers,
      :turn_away_child_care,
      :program_address1,
      :program_address2,
      :program_city,
      :program_state,
      :program_zip_code,
      :max_serve,
      :incorporate_plan,
      :responsible_staff_position,
      :storage_space,
      :describe_storage_space,
      :trusted_pickup,
      :income_requirement_desc,
      :serve_income_circumstances,
      :income_verification,
      :internal_db,
      :maac,
      :population_black,
      :population_white,
      :population_hispanic,
      :population_asian,
      :population_american_indian,
      :population_island,
      :population_multi_racial,
      :population_other,
      :zips_served,
      :at_fpl_or_below,
      :above_1_2_times_fpl,
      :greater_2_times_fpl,
      :poverty_unknown,
      :ages_served,
      :executive_director_name,
      :executive_director_phone,
      :executive_director_email,
      :program_contact_name,
      :program_contact_phone,
      :program_contact_mobile,
      :program_contact_email,
      :pick_up_method,
      :pick_up_name,
      :pick_up_phone,
      :pick_up_email,
      :distribution_times,
      :new_client_times,
      :more_docs_required,
      :sources_of_funding,
      :sources_of_diapers,
      :diaper_budget,
      :diaper_funding_source,
      documents: []
    )
  end

  def pundit_user
    current_partner
  end
end
