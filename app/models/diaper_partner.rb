class DiaperPartner < ApplicationRecord
  self.table_name = 'partners'

  connects_to database: { writing: :diaper_base, reading: :diaper_base }
end