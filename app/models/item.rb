class Item < ApplicationRecord
  belongs_to :partner_request, optional: true
end
