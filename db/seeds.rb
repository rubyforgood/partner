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
    name: "Pawnee Indiana Diaper Bank",
    address1: "123 Main St",
    address2: "",
    city: "Pawnee",
    state: "IN",
    zip_code: 62558,
    website: "http://pawneeindiana.com",
    zips_served: 62558,
    executive_director_email: "leslie@example.com",
    email: "leslie@example.com",
    password: "password",
    partner_status: "approved"
)
puts "Adding a generic 'pending' partner."
Partner.create(
    email: "pending@example.com",
    password: "password"
)
puts "Done creating partners."
