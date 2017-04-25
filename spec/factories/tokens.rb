FactoryGirl.define do
  factory :token do
    association :user, factory: :user
    value SecureRandom.urlsafe_base64(32, false)
  end
end
