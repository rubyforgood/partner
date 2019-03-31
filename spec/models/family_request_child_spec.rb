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

require 'rails_helper'

RSpec.describe FamilyRequestChild, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
