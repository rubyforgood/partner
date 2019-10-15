namespace :counters do
  task update: :environment do
    Partner.find_each do |partner|
      Partner.reset_counters(partner.id, :families)
    end

    Family.find_each do |family|
      Family.reset_counters(family.id, :children)
    end
  end
end
