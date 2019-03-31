# == Schema Information
#
# Table name: children
#
#  id               :bigint(8)        not null, primary key
#  first_name       :string
#  last_name        :string
#  date_of_birth    :date
#  gender           :string
#  child_lives_with :jsonb
#  race             :jsonb
#  agency_child_id  :string
#  health_insurance :jsonb
#  item_needed      :string
#  comments         :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  family_id        :bigint(8)
#

class Child < ApplicationRecord
  belongs_to :family
  has_many :family_request_child, dependent: :destroy
  has_many :family_requests, through: :family_request_child
end
