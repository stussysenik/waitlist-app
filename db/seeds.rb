puts "Seeding database..."

# Create demo user
user = User.find_or_create_by!(email_address: "demo@waitlistapp.com") do |u|
  u.name = "Demo User"
  u.password = "password123"
  u.password_confirmation = "password123"
  u.plan = :starter
  u.trial_ends_at = 30.days.from_now
end
puts "  Created user: #{user.email_address} (password: password123)"

# Create waitlists
waitlists_data = [
  { name: "LaunchPad AI", slug: "launchpad-ai", headline: "The AI-powered project launcher", description: "LaunchPad AI helps you go from idea to shipped product 10x faster. Join the waitlist to be first in line.", brand_color: "#4F46E5", status: :active },
  { name: "FitTrack Pro", slug: "fittrack-pro", headline: "Your personal fitness companion", description: "Track workouts, nutrition, and recovery in one beautiful app. Built by athletes, for athletes.", brand_color: "#059669", status: :active },
  { name: "NomadDesk", slug: "nomaddesk", headline: "Find your perfect remote workspace anywhere", description: "Discover and book coworking spaces, cafes, and quiet spots in any city. Curated by digital nomads.", brand_color: "#D97706", status: :draft }
]

waitlists = waitlists_data.map do |data|
  wl = Waitlist.find_or_create_by!(slug: data[:slug]) do |w|
    w.user = user
    w.name = data[:name]
    w.headline = data[:headline]
    w.description = data[:description]
    w.brand_color = data[:brand_color]
    w.status = data[:status]
    w.referral_enabled = true
  end
  puts "  Created waitlist: #{wl.name} (/#{wl.slug})"
  wl
end

# Create subscribers for active waitlists
waitlists.select(&:active?).each do |waitlist|
  subscriber_count = rand(30..80)
  subscribers = []

  subscriber_count.times do |i|
    sub = waitlist.subscribers.create!(
      email: Faker::Internet.unique.email,
      name: Faker::Name.name,
      ip_address: Faker::Internet.ip_v4_address,
      source: %w[direct referral direct direct twitter].sample,
      created_at: rand(30).days.ago + rand(86400).seconds
    )
    subscribers << sub
  end

  # Create some referrals
  subscribers.sample(subscriber_count / 4).each do |referrer|
    referee = subscribers.sample
    next if referee == referrer
    next if Referral.exists?(referrer: referrer, referee: referee)

    Referral.create(waitlist: waitlist, referrer: referrer, referee: referee)
  end

  # Create daily stats
  30.times do |i|
    date = (30 - i).days.ago.to_date
    DailyStat.find_or_create_by!(waitlist: waitlist, date: date) do |stat|
      stat.signups_count = rand(0..8)
      stat.referrals_count = rand(0..3)
      stat.page_views_count = rand(10..100)
    end
  end

  puts "  Added #{subscriber_count} subscribers to #{waitlist.name}"
end

Faker::UniqueGenerator.clear

puts "Done! Sign in at /session/new with demo@waitlistapp.com / password123"
