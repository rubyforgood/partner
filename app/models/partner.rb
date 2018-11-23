class Partner < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  include DiaperBankClient

  has_one_attached :proof_of_partner_status
  has_one_attached :proof_of_form_990
  has_many_attached :documents

  validates :email, presence: true

  has_many :partner_requests, dependent: :destroy

  def export_json
    {
      name: name,
      distributor_type: distributor_type,
      agency_type: agency_type,
      proof_of_agency_status: expose_attachment_path(proof_of_partner_status),
      agency_mission: agency_mission,
      address: {
        address1: address1,
        address2: address2,
        city: city,
        state: state,
        zip_code: zip_code
      },
      media: {
        website: website,
        facebook: facebook,
        twitter: twitter
      },
      stability: {
        founded: founded,
        form_990: form_990,
        form_990_link: expose_attachment_path(proof_of_form_990),
        program_name: program_name,
        program_description: program_description,
        program_age: program_age,
        case_management: case_management,
        evidence_based: evidence_based,
        evidence_based_description: evidence_based_description,
        program_client_improvement: program_client_improvement,
        diaper_use: diaper_use,
        other_diaper_use: other_diaper_use,
        currently_provide_diapers: currently_provide_diapers,
        turn_away_child_care: turn_away_child_care
      },
      program_address: {
        program_address1: program_address1,
        program_address2: program_address2,
        program_city: program_city,
        program_state: program_state,
        program_zip_code: program_zip_code
      },
      capacity: {
        max_serve: max_serve,
        incorporate_plan: incorporate_plan,
        responsible_staff_position: responsible_staff_position,
        storage_space: storage_space,
        storage_space_description: describe_storage_space
      },
      population_served: {
        income_requirement_description: income_requirement_desc,
        serve_income_circumstances: serve_income_circumstances,
        income_verification: income_verification,
        internal_db: internal_db,
        maac: maac,
        enthnic_composition: {
          african_american: population_black,
          caucasian: population_white,
          hispanic: population_hispanic,
          asian: population_asian,
          american_indain: population_american_indian,
          pacific_island: population_island,
          multi_racial: population_multi_racial,
          other: population_other
        },
        zip_codes_served: zips_served,
        poverty_information: {
          at_fpl_or_below: at_fpl_or_below,
          above_1_2_times_fpl: above_1_2_times_fpl,
          greater_2_times_fpl: greater_2_times_fpl,
          poverty_unknown: poverty_unknown
        },
        ages_served: ages_served
      },
      executive_director: {
        name: executive_director_name,
        phone: executive_director_phone,
        email: executive_director_email
      },
      contact_person: {
        name: program_contact_name,
        phone: program_contact_phone,
        mobile: program_contact_mobile,
        email: program_contact_email
      },
      pick_up_person: {
        method: pick_up_method,
        name: pick_up_name,
        phone: pick_up_phone,
        email: pick_up_email
      },
      distribution: {
        distribution_times: distribution_times,
        new_client_times: new_client_times,
        more_docs_required: more_docs_required
      },
      funding: {
        source: sources_of_funding,
        diapers: sources_of_diapers,
        budget: diaper_budget,
        diaper_funding_source: diaper_funding_source
      },
      documents: document_list
    }
  end

  def approve_me
    update(partner_status: "Submitted")
    DiaperBankClient.post(diaper_partner_id)
  end

  def verified?
    partner_status.casecmp("verified").zero?
  end

  def pending?
    partner_status.casecmp("pending").zero?
  end

  private

  def expose_attachment_path(documentation)
    # NOTE(chaserx): I'm not sure how I feel about this.
    #    I think smells because the `export_json` method should probably be
    #    a jbuilder view or similar where url_helpers are already available.
    # Also, we have to use the `only_path` option here or else we need to set
    #    `default_url_options` to a domain name. That might be ok though as
    #    the diaper app probably has knowledge of that anyway.
    if documentation.attached?
      Rails.application.routes.url_helpers.rails_blob_path(documentation, only_path: true)
    else
      ""
    end
  end

  def document_list
    # NOTE(chaserx): see same note as above.
    list = []
    documents.each do |doc|
      list.push(document_link: Rails.application.routes.url_helpers.rails_blob_path(doc, only_path: true))
    end
    list
  end
end
