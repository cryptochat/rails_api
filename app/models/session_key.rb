class SessionKey < ApplicationRecord
  require 'securerandom'
  require 'base64'
  require 'rbnacl'

  before_create :generate_uuid
  before_create :generate_keys

  def self.exchange(uuid, base64_public_key)
    session_key = SessionKey.find_by(uuid: uuid)
    if session_key.present?
      public_key = Base64.decode64(base64_public_key)
      session_key.shared_key = RbNaCl::GroupElement.new(public_key).mult(session_key.private_key)
      session_key.save
    end
  end

  def base64_public_key
    Base64.encode64(public_key)
  end

  private

    def generate_uuid
      self.uuid = loop do
        random_uuid = SecureRandom.uuid
        break random_uuid unless self.class.exists?(uuid: random_uuid)
      end
    end

    def generate_keys
      self.private_key = SecureRandom.random_bytes(32)
      self.public_key  = RbNaCl::GroupElement.base.mult(private_key)
    end

end
