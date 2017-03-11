class Token < ApplicationRecord
  belongs_to :user

  before_save :token_generate

  def self.generate_token(user)
    tokens = user.tokens.order(updated_at: :desc)
    if tokens.count >= 3
      tokens.last.touch
      tokens.last.save
      tokens.last
    else
      create user_id: user.id
    end
  end

  private

  def token_generate
    self.value = loop do
      random_token = SecureRandom.urlsafe_base64(32, false)
      break random_token unless self.class.exists?(value: random_token)
    end
  end
end
