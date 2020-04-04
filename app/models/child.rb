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
  serialize :child_lives_with, Array
  belongs_to :family
  has_many :family_request_child, dependent: :destroy
  has_many :family_requests, through: :family_request_child
  has_many :child_item_requests, dependent: :destroy

  include Filterable
  scope :from_family, ->(family_id) {
    where(family_id: family_id)
  }
  scope :from_children, ->(chidren_id) {
    where(id: chidren_id)
  }
  scope :active, -> { where(active: true) }

  CSV_HEADERS = %w[
    id first_name last_name date_of_birth gender child_lives_with race agency_child_id
    health_insurance comments created_at updated_at family_id item_needed_diaperid active archived
  ].freeze
  CAN_LIVE_WITH = %w[Mother Father Grandparent Foster\ Parent Other\ Parent/Relative].freeze
  RACES = %w[African\ American Caucasian Hispanic Asian American\ Indian Pacific\ Islander Multi-racial Other].freeze
  CHILD_ITEMS = ["Bed Pads (Cloth)",
                 "Bed Pads (Disposable)",
                 "Bibs (Adult & Child)",
                 "Cloth Diapers (AIO's/Pocket)",
                 "Cloth Diapers (Covers)",
                 "Cloth Diapers (Plastic Cover Pants)",
                 "Cloth Diapers (Prefolds & Fitted)",
                 "Cloth Inserts (For Cloth Diapers)",
                 "Cloth Potty Training Pants/Underwear",
                 "Cloth Swimmers (Kids)",
                 "Diaper Rash Cream/Powder",
                 "Disposable Inserts",
                 "Kids (Newborn)",
                 "Kids (Preemie)",
                 "Kids (Size 1)",
                 "Kids (Size 2)",
                 "Kids (Size 3)",
                 "Kids (Size 4)",
                 "Kids (Size 5)",
                 "Kids (Size 6)",
                 "Kids (Size 7)",
                 "Kids S/M (38-65 lbs)",
                 "Kids L/XL (60-125 lbs)",
                 "Kids Pull-Ups (2T-3T)",
                 "Kids Pull-Ups (3T-4T)",
                 "Kids Pull-Ups (4T-5T)",
                 "Other Wipes (Baby)"].freeze

  def display_name
    "#{first_name} #{last_name}"
  end

  def self.csv_headers
    CSV_HEADERS
  end

  def to_csv
    [
      id,
      first_name,
      last_name,
      date_of_birth,
      gender,
      child_lives_with,
      race,
      agency_child_id,
      health_insurance,
      comments,
      created_at,
      updated_at,
      family_id,
      item_needed_diaperid,
      active,
      archived
    ]
  end

  def export_json
    { id: id, first_name: first_name, last_name: last_name, date_of_birth: date_of_birth, gender: gender, child_lives_with: child_lives_with, race: race, agency_child_id: agency_child_id, health_insurance: health_insurance, comments: comments, created_at: created_at, updated_at: updated_at, family_id: family_id, item_needed_diaperid: item_needed_diaperid, active: active, archived: archived }
  end
end
