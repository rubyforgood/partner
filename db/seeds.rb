require 'faker'

puts "Creating partners..."
puts "Adding an 'approved' partner."
Partner.create(
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
    email: "verified@example.com",
    password: "password",
    partner_status: "Verified"
)

puts "Adding a generic 'pending' partner."
pending_user_name = Faker::Name.name
Partner.create(
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
    executive_director_email: "unverified@example.com",
    email: "unverified@example.com",
    password: "password"
)

puts "Adding a 'invited' partner."
Partner.create(
    name: "Pawnee Homeless Shelter",
    email: "anyone@pawneehomelss.com",
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
    executive_director_email: "anyone@pawneehomelss.com",
    password: "password"
)

puts "Adding a 'invited' partner."
Partner.create(
    name: "Pawnee Pregnancy Center",
    email: "contactus@pawneepregnancy.com",
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
    executive_director_email: "contactus@pawneepregnancy.com",
    password: "password"
)

puts "Adding a 'recertification_required' partner."
Partner.create(
    name: "Pawnee Senior Citizens Center",
    email: "help@pscc.org",
    partner_status: "recertification_required",
    diaper_bank_id: 1,
    diaper_partner_id: 5,
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
    executive_director_email: "help@pscc.org",
    password: "password"
)

puts "Done creating partners."
