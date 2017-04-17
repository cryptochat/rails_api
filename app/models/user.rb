class User < ApplicationRecord
  validates :uuid,       uniqueness: true
  validates :email,      presence: true, uniqueness: true, email: true
  validates :username,   presence: true, uniqueness: true
  validates :password,   presence: true, length: { minimum: 6 }
  validates :first_name, presence: true, length: { minimum: 2 }
  validates :last_name,  presence: true, length: { minimum: 2 }

  has_many :tokens
  has_and_belongs_to_many :chat_channels

  before_create :generate_uuid
  before_save :encrypt_password, if: :password_changed?
  before_save :set_full_name

  def self.paginate(offset = 0, limit = 20)
    select(:id, :full_name).order(:full_name).offset(offset).limit(limit)
  end

  def self.search(query)
    query = "%#{query.downcase}%"
    select(:id, :full_name).where('full_name ILIKE ?', query)
  end

  def self.auth(login, password)
    sha512 = OpenSSL::Digest::SHA512.new
    password = sha512.digest(password.to_s + ENV['SALT'])
    user = where('username = :login or email = :login', login: login).where(password: password).take
    Token.generate_token(user).value if user.present?
    user
  end

  def token
    tokens.order(updated_at: :desc).first.value
  end

  def chat_list
    ChatMessage.interlocutors(id)
  end

  def chat_history(interlocutor_id, offset = 0, limit = 20)
    ChatMessage.history(id, interlocutor_id, offset, limit)
  end

  def appear
    update_column(:is_online, true)
  end

  def disappear
    update_column(:is_online, false)
  end

  def online?
    is_online
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
    self.password = sha512.digest(password.to_s + ENV['SALT'])
  end

  def set_full_name
    self.full_name = "#{first_name} #{last_name}"
  end
end
