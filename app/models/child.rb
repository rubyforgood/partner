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
#  archived             :boolean
#

class Child < ApplicationRecord
  CAN_LIVE_WITH = %w[Mother Father Grandparent Foster\ Parent Other\ Parent/Relative].freeze
  serialize :child_lives_with, Array
  belongs_to :family, counter_cache: true
  has_many :family_request_child, dependent: :destroy
  has_many :family_requests, through: :family_request_child

  scope :active, -> { where(active: true) }
end
