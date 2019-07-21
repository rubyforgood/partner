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

FactoryBot.define do
  factory :partner do
    name { "Partner" }
    sequence(:email) { |n| "partner#{n}@email.com" }
    password { "password" }
    address1 { Faker::Address.street_address }

    after(:create) do |partner|
      partner.diaper_partner_id = partner.id
      partner.diaper_bank_id = partner.id
      partner.save!
    end

    trait(:approved) do
      partner_status { "approved" }
    end

    trait(:verified) do
      partner_status { "Verified" }
    end

    trait(:recertification_required) do
      partner_status { "Recertification Required" }
    end

    trait(:submitted) do
      partner_status { "submitted" }
    end

    trait(:with_990_attached) do
      proof_of_form_990 { fixture_file_upload(Rails.root.join("spec", "support", "dummy_pdfs", "f990.pdf"), "application/pdf") }
    end

    trait(:with_status_proof) do
      proof_of_partner_status { fixture_file_upload(Rails.root.join("spec", "support", "dummy_pdfs", "status_proof.pdf"), "application/pdf") }
    end

    trait(:with_other_documents) do
      documents do
        [
          fixture_file_upload(Rails.root.join("spec", "support", "dummy_pdfs", "document1.pdf"), "application/pdf"),
          fixture_file_upload(Rails.root.join("spec", "support", "dummy_pdfs", "document2.pdf"), "application/pdf")
        ]
      end
    end
  end
end
