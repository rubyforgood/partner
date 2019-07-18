# == Schema Information
#
# Table name: partners
#
#  id                         :bigint(8)        not null, primary key
#  diaper_bank_id             :integer
#  executive_director_name    :string
#  program_contact_name       :string
#  pick_up_name               :string
#  application_data           :text
#  diaper_partner_id          :integer
#  partner_status             :string           default("pending")
#  name                       :string
#  distributor_type           :string
#  agency_type                :string
#  agency_mission             :text
#  address1                   :string
#  address2                   :string
#  city                       :string
#  state                      :string
#  zip_code                   :string
#  website                    :string
#  facebook                   :string
#  twitter                    :string
#  founded                    :integer
#  form_990                   :boolean
#  program_name               :string
#  program_description        :text
#  program_age                :string
#  case_management            :boolean
#  evidence_based             :boolean
#  evidence_based_description :text
#  program_client_improvement :text
#  diaper_use                 :string
#  other_diaper_use           :string
#  currently_provide_diapers  :boolean
#  turn_away_child_care       :boolean
#  program_address1           :string
#  program_address2           :string
#  program_city               :string
#  program_state              :string
#  program_zip_code           :integer
#  max_serve                  :string
#  incorporate_plan           :text
#  responsible_staff_position :boolean
#  storage_space              :boolean
#  describe_storage_space     :text
#  trusted_pickup             :boolean
#  income_requirement_desc    :boolean
#  serve_income_circumstances :boolean
#  income_verification        :boolean
#  internal_db                :boolean
#  maac                       :boolean
#  population_black           :integer
#  population_white           :integer
#  population_hispanic        :integer
#  population_asian           :integer
#  population_american_indian :integer
#  population_island          :integer
#  population_multi_racial    :integer
#  population_other           :integer
#  zips_served                :string
#  at_fpl_or_below            :integer
#  above_1_2_times_fpl        :integer
#  greater_2_times_fpl        :integer
#  poverty_unknown            :integer
#  ages_served                :string
#  executive_director_phone   :string
#  executive_director_email   :string
#  program_contact_phone      :string
#  program_contact_mobile     :string
#  program_contact_email      :string
#  pick_up_method             :string
#  pick_up_phone              :string
#  pick_up_email              :string
#  distribution_times         :string
#  new_client_times           :string
#  more_docs_required         :string
#  sources_of_funding         :string
#  sources_of_diapers         :string
#  diaper_budget              :string
#  diaper_funding_source      :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  email                      :string           default(""), not null
#  encrypted_password         :string           default(""), not null
#  reset_password_token       :string
#  reset_password_sent_at     :datetime
#  remember_created_at        :datetime
#  sign_in_count              :integer          default(0), not null
#  current_sign_in_at         :datetime
#  last_sign_in_at            :datetime
#  current_sign_in_ip         :string
#  last_sign_in_ip            :string
#  invitation_token           :string
#  invitation_created_at      :datetime
#  invitation_sent_at         :datetime
#  invitation_accepted_at     :datetime
#  invitation_limit           :integer
#  invited_by_type            :string
#  invited_by_id              :bigint(8)
#  invitations_count          :integer          default(0)
#

class Partner < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  ACTIVE_FAMILY_REQUESTS = [3, 27].freeze

  devise :invitable, :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  include DiaperBankClient

  has_one_attached :proof_of_partner_status
  has_one_attached :proof_of_form_990
  has_many_attached :documents

  has_many :families, dependent: :destroy
  has_many :children, through: :families
  has_many :authorized_family_members, through: :families

  validates :email, presence: true

  has_many :partner_requests, dependent: :destroy
  has_many :family_requests, dependent: :destroy

  def export_json
    {
      name: name,
      distributor_type: distributor_type,
      agency_type: agency_type,
      other_agency_type: other_agency_type,
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

  def family_request_active?
    ACTIVE_FAMILY_REQUESTS.include?(diaper_bank_id)
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
