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

class Family < ApplicationRecord
  belongs_to :partner
  has_many :children, dependent: :destroy
  has_many :authorized_family_members, dependent: :destroy
  serialize :sources_of_income, Array
  validates :guardian_first_name, :guardian_last_name, :guardian_zip_code, presence: true

  INCOME_TYPES = %w[SSI SNAP/FOOD\ Stamps TANF WIC Housing/subsidized Housing/unsubsidized N/A].freeze
  INSURANCE_TYPES = %w[Private\ insurance Medicaid Uninsured].freeze
  EMPLOYMENT_TYPES = %w[Full-time Part-time N/A].freeze

  after_create :create_authorized

  def create_authorized
    authorized_family_members.create!(
      first_name: guardian_first_name,
      last_name: guardian_last_name
    )
  end

  def guardian_display_name
    "#{guardian_first_name} #{guardian_last_name}"
  end

  def total_children_count
    home_child_count + home_young_child_count
  end
end
