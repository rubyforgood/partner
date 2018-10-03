FactoryBot.define do
  factory :partner do
    name { 'Partner' }
    email { 'parter@email.com' }
    password {'password'}
    address1 { Faker::Address.street_address }

    trait(:approved) do
      partner_status { 'approved' }
    end
  end
end