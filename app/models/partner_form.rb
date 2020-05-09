class PartnerForm < ApplicationRecord
  validates :diaper_bank_id, presence: true, uniqueness: true # rubocop:disable Rails/UniqueValidationWithoutIndex
end