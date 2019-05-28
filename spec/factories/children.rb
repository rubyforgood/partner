# == Schema Information
#
# Table name: children
#
#  id                   :bigint(8)        not null, primary key
#  first_name           :string
#  last_name            :string
#  date_of_birth        :date
#  gender               :string
#  child_lives_with     :jsonb
#  race                 :jsonb
#  agency_child_id      :string
#  health_insurance     :jsonb
#  comments             :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  family_id            :bigint(8)
#  item_needed_diaperid :integer
#  active               :boolean          default(TRUE)
#

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
