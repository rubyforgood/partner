class PartnerRequestBlueprint < Blueprinter::Base
  identifier :id
  fields :partner_id, :organization_id, :comments
  association :items, name: :requested_items, blueprint: ItemBlueprint, default: {}
end
