FactoryBot.define do
  factory :partner do
    name { "Partner" }
    sequence(:email) { |n| "parter#{n}@email.com" }
    password { "password" }
    address1 { Faker::Address.street_address }

    after(:create) do |partner|
      partner.diaper_partner_id = partner.id
      partner.diaper_bank_id = partner.id
      partner.save!
    end

    trait(:approved) do
      partner_status { "approved" }
    end
  end
end
