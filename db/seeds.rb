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
User.create(
    password: "password",
    password_confirmation: "password",
    email: "verified@example.com",
    partner: verified_partner
)

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
    password: "password",
    password_confirmation: "password",
    email: "recertification@example.com",
    partner: recertification_required_partner
)

puts "Done creating partners."
