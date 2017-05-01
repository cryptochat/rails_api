# generating users
30.times do |i|
  email = Faker::Internet.email
  first_name = Faker::Name.unique.first_name
  last_name = Faker::Name.unique.last_name
  username = "#{first_name}_#{last_name}".downcase
  User.create(email: email, username: username, first_name: first_name, last_name: last_name, password: '12345678')
end

# generating messages

users = User.all
50.times do |i|
  puts i
  users.each do |sender|
    users.each do |recipient|
      next if recipient == sender
      next if rand > 0.5

      ChatMessage.send_message(sender.id, recipient.id, Faker::Lorem.sentence(rand(1..20)))
    end
  end
end

# clear unique
Faker::UniqueGenerator.clear
