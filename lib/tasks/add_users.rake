desc 'Adds 1,000,000 random user records'
task add_users: :environment do
  require_relative '../user'
  require 'parallel'
  require 'faker'
  Parallel.each((1..1_000_000).to_a, in_processes: Parallel.processor_count) do |num|
    User.create(
      details: {
        address: {
          city: Faker::Address.city,
          street_address: Faker::Address.street_address,
          zip: Faker::Address.zip,
          state: Faker::Address.state_abbr
        },
        contact_me: [true, false].sample,
        first_name: Faker::Name.first_name,
        last_name: Faker::Name.last_name,
        age: (( rand * 22 ).to_i + 18),
        bio: Faker::Lorem.paragraph(3, true)
      }
    )
  end
end
