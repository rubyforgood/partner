# == Schema Information
#
# Table name: family_requests
#
#  id         :bigint(8)        not null, primary key
#  partner_id :bigint(8)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  sent       :boolean
#

require "rails_helper"

RSpec.describe FamilyRequest, type: :model do
end
