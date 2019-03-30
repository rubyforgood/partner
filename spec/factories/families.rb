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
    sources_of_income { "" }
    guardian_employed { false }
    guardian_employment_type { "" }
    guardian_monthly_pay { "9.99" }
    guardian_health_insurance { "" }
    comments { "MyText" }
  end
end
