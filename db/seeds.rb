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