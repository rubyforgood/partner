# == Schema Information
#
# Table name: authorized_family_members
#
#  id            :bigint(8)        not null, primary key
#  first_name    :string
#  last_name     :string
#  date_of_birth :date
#  gender        :string
#  comments      :text
#  family_id     :bigint(8)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :authorized_family_member do
    first_name { "MyString" }
    last_name { "MyString" }
  end
end
