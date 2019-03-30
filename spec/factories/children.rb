FactoryBot.define do
  factory :child do
    first_name { "MyString" }
    last_name { "MyString" }
    date_of_birth { "2019-03-30" }
    gender { "MyString" }
    child_lives_with { "" }
    race { "" }
    agency_child_id { "MyString" }
    health_insurance { "" }
    item_needed { "MyString" }
    comments { "MyText" }
  end
end
