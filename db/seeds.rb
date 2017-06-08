# listing 10.43

User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true, 								# listing 10.55
             activated: true,             # listing 11.4
             activated_at: Time.zone.now
             )

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password,
               activated: true,           # listing 11.4
               activated_at: Time.zone.now
               )
end

# listing 13.25 - adds 50 microposts to each of 1st 6 fake users

users = User.order(:created_at).take(6)

50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end
