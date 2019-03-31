# == Schema Information
#
# Table name: family_request_children
#
#  id                :bigint(8)        not null, primary key
#  family_request_id :bigint(8)
#  child_id          :bigint(8)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class FamilyRequestChild < ApplicationRecord
  # A join table between families and children
  belongs_to :family_request
  belongs_to :child
end
