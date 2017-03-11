FactoryGirl.define do
  factory :session_key do
    public_key SecureRandom.random_bytes(32)
    private_key SecureRandom.random_bytes(32)
    shared_key SecureRandom.random_bytes(32)
  end
end
