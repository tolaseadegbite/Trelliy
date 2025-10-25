# db/seeds.rb

require 'faker'

puts "🌱 Seeding database..."

# --- 1. Clean up old data ---
puts "🗑️  Destroying existing Events, Contacts, Users, and Accounts..."
Event.destroy_all
Contact.destroy_all
User.destroy_all
Account.destroy_all
puts "✅ Old data destroyed."


# --- 2. Create a default Account and User ---
puts "\n🏢 Creating a default Account..."
account = Account.create!
puts "✅ Default Account created."

puts "\n👤 Creating the default User..."
begin
  user = User.create!(
    email: "tolase@test.com",
    name: "Tolase Kelvin",
    account: account,
    password: "tolasekelvin",
    password_confirmation: "tolasekelvin",
    verified: true
  )
  puts "✅ Default User 'Tolase Kelvin' created with email 'tolase@test.com'."
rescue => e
  puts "❌ Error creating user: #{e.message}"
  exit
end


# --- 3. Seed Contacts for the default User ---
puts "\nPreparing 5,000 contacts..."

contacts_to_create = []
how_we_met_options = ["Networking Event", "Referral", "Social Media", "Cold Outreach", "Inbound Lead"]

5000.times do
  contacts_to_create << {
    owner_type: 'User',
    owner_id: user.id,
    creator_id: user.id, # <<< THE FIX IS HERE
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    phone_number: Faker::PhoneNumber.phone_number,
    how_we_met: how_we_met_options.sample,
    created_at: Time.current,
    updated_at: Time.current
  }
end

puts "Inserting 5,000 contacts into the database..."
Contact.insert_all(contacts_to_create)
puts "✅ 5,000 contacts created."


# --- 4. Seed Events for the default User ---
puts "\nPreparing 100 events..."

events_to_create = []
event_names = ["Project Kickoff", "Quarterly Review", "Client Follow-up", "Team Stand-up", "Design Sprint", "Marketing Sync"]
durations = [15, 30, 45, 60, 90]

100.times do
  events_to_create << {
    owner_type: 'User',
    owner_id: user.id,
    name: event_names.sample,
    starts_at: Faker::Time.forward(days: 60, period: :all),
    duration_in_minutes: durations.sample,
    created_at: Time.current,
    updated_at: Time.current
  }
end

puts "Inserting 100 events into the database..."
Event.insert_all(events_to_create)
puts "✅ 100 events created."


puts "\n🎉 Seeding complete!"