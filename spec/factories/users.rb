FactoryGirl.define do
  sequence(:username)   { |n| "username#{n}" }
  sequence(:email)      { |n| "example#{n}@mail.com" }
  sequence(:first_name) { |n| "first_name_#{n}" }
  sequence(:last_name)  { |n| "last_name_#{n}" }

  factory :user do
    email
    username
    first_name
    last_name
    password '123456'
  end
end
