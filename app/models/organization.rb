class Organization < ApplicationRecord
  connects_to database: { writing: :diaper_base, reading: :diaper_base }
end