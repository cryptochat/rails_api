class User < ApplicationRecord
  validates :uuid,       uniqueness: true
  validates :email,      presence: true, uniqueness: true, email: true
  validates :username,   presence: true, uniqueness: true
  validates :password,   presence: true, length: { minimum: 6 }
  validates :first_name, presence: true
  validates :last_name,  presence: true

  has_many :tokens

  before_create :generate_uuid
  before_save :encrypt_password, if: :password_changed?

  def self.auth(login, password)
    sha512 = OpenSSL::Digest::SHA512.new
    password = sha512.digest(password.to_s)
    user = where('username = :login or email = :login', login: login).where(password: password).limit(1).first
    Token.generate_token(user).value if user.present?
    user
  end

  def token
    tokens.order(updated_at: :desc).first.value
  end

  private

  def generate_uuid
    self.uuid = loop do
      random_uuid = SecureRandom.uuid
      break random_uuid unless self.class.exists?(uuid: random_uuid)
    end
  end

  def encrypt_password
    sha512 = OpenSSL::Digest::SHA512.new
    self.password = sha512.digest(password.to_s)
  end
end
