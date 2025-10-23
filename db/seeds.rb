# Find the first user to assign the contacts to.
# The `first!` method will raise an error if no user is found, which is
# good because the script cannot continue without a user.
begin
  user = User.first!
rescue ActiveRecord::RecordNotFound
  puts "Error: No users found in the database. Please create a user before running the seed."
  exit
end


puts "Preparing to create 5,000 contacts for user: #{user.email}..."

# Prepare an array to hold all the contact attributes
contacts_to_create = []

# Define a set of options for "how_we_met"
how_we_met_options = ["Networking Event", "Referral", "Social Media", "Cold Outreach", "Inbound Lead"]

# Use `times` to loop 5,000 times
5000.times do |i|
  contacts_to_create << {
    owner_type: 'User',
    owner_id: user.id,
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email, # .unique ensures no duplicates
    phone_number: Faker::PhoneNumber.phone_number,
    how_we_met: how_we_met_options.sample, # Pick a random value from the array
    created_at: Time.current,
    updated_at: Time.current
  }
  
  # Print progress every 500 records
  if (i + 1) % 500 == 0
    puts "Prepared #{i + 1}/5000 contacts..."
  end
end

puts "\nStarting bulk insert of 5,000 contacts. This may take a moment..."

# Use `insert_all` for a single, highly efficient database operation.
# This is much faster than `Contact.create` in a loop.
Contact.insert_all(contacts_to_create)

puts "\n✅ Success! Database has been seeded with 5,000 contacts for #{user.email}."