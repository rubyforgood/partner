# == Schema Information
#
# Table name: families
#
#  id                        :bigint(8)        not null, primary key
#  guardian_first_name       :string
#  guardian_last_name        :string
#  guardian_zip_code         :string
#  guardian_country          :string
#  guardian_phone            :string
#  agency_guardian_id        :string
#  home_adult_count          :integer
#  home_child_count          :integer
#  home_young_child_count    :integer
#  sources_of_income         :jsonb
#  guardian_employed         :boolean
#  guardian_employment_type  :jsonb
#  guardian_monthly_pay      :decimal(, )
#  guardian_health_insurance :jsonb
#  comments                  :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  partner_id                :bigint(8)
#  military                  :boolean          default(FALSE)
#

FactoryBot.define do
  factory :family do
    guardian_first_name { "MyString" }
    guardian_last_name { "MyString" }
    guardian_zip_code { "MyString" }
    guardian_country { "MyString" }
    guardian_phone { "MyString" }
    agency_guardian_id { "MyString" }
    home_adult_count { 1 }
    home_child_count { 1 }
    home_young_child_count { 1 }
    sources_of_income { ["WIC"] }
    guardian_employed { false }
    guardian_employment_type { "" }
    guardian_monthly_pay { "9.99" }
    guardian_health_insurance { "Uninsured" }
    military { false }
    comments { "MyText" }
    partner
  end
end
