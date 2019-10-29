require 'faker'

puts "Creating partners..."
puts "Adding an 'approved' partner and user."
verified_partner = Partner.create(
    executive_director_name: "Leslie Knope",
    program_contact_name: "Leslie Knope",
    name: "Pawnee Parent Service",
    address1: "123 Main St",
    address2: "",
    city: "Pawnee",
    state: "IN",
    zip_code: 62558,
    website: "http://pawneeindiana.com",
    zips_served: 62558,
    diaper_bank_id: 1,
    diaper_partner_id: 1,
    executive_director_email: "verified@example.com",
    partner_status: "verified"
)
Flipper[:family_requests].enable(verified_partner)
User.create(
    name: Faker::Name.name,
    password: "password",
    password_confirmation: "password",
    email: "verified@example.com",
    partner: verified_partner
)
puts "Adding families."
Faker::Number.within(range: 4..13).times do
    Family.create(
        guardian_first_name: Faker::Name.first_name,
        guardian_last_name: Faker::Name.last_name,
        guardian_zip_code: Faker::Address.zip_code,
        guardian_country: "United States",
        guardian_phone: Faker::PhoneNumber.phone_number,
        agency_guardian_id: Faker::Name.name,
        home_adult_count: [1, 2, 3].sample,
        home_child_count: [0, 1, 2, 3, 4, 5].sample,
        home_young_child_count: [1, 2, 3, 4].sample,
        sources_of_income: Family::INCOME_TYPES.sample(2),
        guardian_employed: Faker::Boolean.boolean,
        guardian_employment_type: Family::EMPLOYMENT_TYPES.sample,
        guardian_monthly_pay: [1, 2, 3, 4].sample,
        guardian_health_insurance: Family::INSURANCE_TYPES.sample,
        comments: Faker::Lorem.paragraph,
        military: false,
        partner: verified_partner
    )
end

puts "Adding children."
Family.all.each do |family|
    family.home_child_count.times do
        Child.create(
            family: family,
            first_name: Faker::Name.first_name,
            last_name: family.guardian_last_name,
            date_of_birth: Faker::Date.birthday(min_age: 5, max_age: 18),
            gender: Faker::Gender.binary_type,
            child_lives_with: Child::CAN_LIVE_WITH.sample(2),
            race: Child::RACES.sample,
            agency_child_id: family.agency_guardian_id,
            health_insurance: family.guardian_health_insurance,
            comments: Faker::Lorem.paragraph,
            active: Faker::Boolean.boolean,
            archived: false,
            item_needed_diaperid: Child::CHILD_ITEMS.sample
        )
    end
    family.home_young_child_count.times do
        Child.create(
            family: family,
            first_name: Faker::Name.first_name,
            last_name: family.guardian_last_name,
            date_of_birth: Faker::Date.birthday(min_age: 0, max_age: 5),
            gender: Faker::Gender.binary_type,
            child_lives_with: Child::CAN_LIVE_WITH.sample(2),
            race: Child::RACES.sample,
            agency_child_id: family.agency_guardian_id,
            health_insurance: family.guardian_health_insurance,
            comments: Faker::Lorem.paragraph,
            active: Faker::Boolean.boolean,
            archived: false,
            item_needed_diaperid: Child::CHILD_ITEMS.sample
        )
    end
end

puts "Adding authorized family members."
Family.all.each do |family|
    AuthorizedFamilyMember.create(
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        date_of_birth: Faker::Date.birthday(min_age: 18, max_age: 100),
        gender: Faker::Gender.binary_type,
        comments: Faker::Lorem.paragraph,
        family: family
    )
end

puts "Adding diaper requests."
Faker::Number.within(range: 32..56).times do
    PartnerRequest.create(
        comments: Faker::Lorem.paragraph,
        partner: verified_partner,
        for_families: Faker::Boolean.boolean
    )
end

PartnerRequest.all.each do |pr|
    ItemRequest.create(
        name: Child::CHILD_ITEMS.sample,
        quantity: Faker::Number.within(range: 10..30),
        partner_request_id: pr.id,
        partner_key: Child::CHILD_ITEMS.sample,
        item_id: Faker::Number.within(range: 1..20)
    )
end

PartnerRequest.all.each do |pr|
    if pr.for_families
        pr.item_requests.each do |request|
            ChildItemRequest.create(
                child_id: Child.all.sample,
                item_request: request,
                picked_up: Faker::Boolean.boolean,
                quantity_picked_up: Faker::Number.within(range: 10..30),
                picked_up_item_diaperid: Child::CHILD_ITEMS.sample,
                authorized_family_member: nil
            )
        end
    end
end

puts "Adding a generic 'pending' partner and user."
pending_user_name = Faker::Name.name
unverified_partner = Partner.create(
    executive_director_name: pending_user_name,
    program_contact_name: pending_user_name,
    name: "County Diaper Bank",
    address1: Faker::Address.street_address,
    address2: "",
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    zip_code: Faker::Address.zip,
    website: Faker::Internet.domain_name,
    zips_served: Faker::Address.zip,
    executive_director_email: "unverified@example.com"
)
User.create(
    name: Faker::Name.name,
    password: "password",
    password_confirmation: "password",
    email: "unverified@example.com",
    partner: unverified_partner
)

puts "Adding an 'invited' partner and user."
invited_partner_1 = Partner.create(
    partner_status: "invited",
    diaper_bank_id: 1,
    diaper_partner_id: 2,
    executive_director_name: Faker::Name.name,
    program_contact_name: Faker::Name.name,
    name: "County Diaper Bank",
    address1: Faker::Address.street_address,
    address2: "",
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    zip_code: Faker::Address.zip,
    website: Faker::Internet.domain_name,
    zips_served: Faker::Address.zip,
    executive_director_email: "anyone@pawneehomelss.com"
)
User.create(
    password: "password",
    password_confirmation: "password",
    email: "invited_partner_1@example.com",
    partner: invited_partner_1
)

puts "Adding an 'invited' partner and user."
invited_partner_2 = Partner.create(
    partner_status: "invited",
    diaper_bank_id: 1,
    diaper_partner_id: 3,
    executive_director_name: Faker::Name.name,
    program_contact_name: Faker::Name.name,
    name: "County Diaper Bank",
    address1: Faker::Address.street_address,
    address2: "",
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    zip_code: Faker::Address.zip,
    website: Faker::Internet.domain_name,
    zips_served: Faker::Address.zip,
    executive_director_email: "contactus@pawneepregnancy.com"
)
User.create(
    name: Faker::Name.name,
    password: "password",
    password_confirmation: "password",
    email: "invited_partner_2@example.com",
    partner: invited_partner_2
)


puts "Adding a 'recertification_required' partner and user."
recertification_required_partner = Partner.create(
    name: "Pawnee Senior Citizens Center",
    partner_status: "recertification_required",
    diaper_bank_id: 1,
    diaper_partner_id: 5,
    executive_director_name: Faker::Name.name,
    program_contact_name: Faker::Name.name,
    address1: Faker::Address.street_address,
    address2: "",
    city: Faker::Address.city,
    state: Faker::Address.state_abbr,
    zip_code: Faker::Address.zip,
    website: Faker::Internet.domain_name,
    zips_served: Faker::Address.zip,
    executive_director_email: "help@pscc.org"
)
User.create(
    name: Faker::Name.name,
    password: "password",
    password_confirmation: "password",
    email: "recertification@example.com",
    partner: recertification_required_partner
)

puts "Done creating partners."
