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

    trait :with_token do
      after(:create) do |user|
        create_list(:token, 1, user: user)
      end
    end
  end
end
