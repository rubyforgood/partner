require 'faker'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "Creating partners..."
puts "Adding an 'approved' partner."
Partner.create(
    executive_director_name: "Leslie Knope",
    program_contact_name: "Leslie Knope",
    name: "Pawnee Indiana Diaper Bank Partner",
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
puts "Done creating partners."
