# == Schema Information
#
# Table name: family_requests
#
#  id         :bigint(8)        not null, primary key
#  partner_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class FamilyRequest < ApplicationRecord
  belongs_to :partner
  has_many :family_request_children, dependent: :destroy
  has_many :children, through: :family_request_children
end
