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
    association :family
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    date_of_birth { Faker::Date.backward(14).iso8601 }
    active { true }
    gender { Faker::Gender.type }
    child_lives_with { ["Mother"] }
    race { "Unknown" }
    item_needed_diaperid { 1 }
    agency_child_id { "Agency" }
    health_insurance { "Blue Rabbit" }
    comments { "What's up" }
  end
end
