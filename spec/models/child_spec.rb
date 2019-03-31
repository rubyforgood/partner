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

require 'rails_helper'

RSpec.describe Child, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
