class PopulatePartnerFamiliesCount < ActiveRecord::Migration[5.2]
  def up
    Partner.find_each do |partner|
      Partner.reset_counters(partner.id, :families)
    end
  end
end
