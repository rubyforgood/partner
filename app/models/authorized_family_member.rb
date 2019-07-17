# == Schema Information
#
# Table name: authorized_family_members
#
#  id                   :bigint(8)        not null, primary key
#  first_name           :string
#  last_name            :string
#  date_of_birth        :date
#  gender               :string
#  comments             :text
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  family_id            :bigint(8)

class AuthorizedFamilyMember < ApplicationRecord
  belongs_to :family
end
