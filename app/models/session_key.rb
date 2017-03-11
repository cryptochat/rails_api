class SessionKey < ApplicationRecord
  require 'securerandom'
  require 'base64'
  require 'rbnacl'

  before_create :generate_identifier
  before_create :generate_keys

  def self.exchange(identifier, base64_public_key)
    session_key = SessionKey.find_by(identifier: identifier)
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

  def generate_identifier
    self.identifier = loop do
      random_uuid = SecureRandom.uuid
      break random_uuid unless self.class.exists?(identifier: random_uuid)
    end
  end

  def generate_keys
    self.private_key = SecureRandom.random_bytes(32)
    self.public_key  = RbNaCl::GroupElement.base.mult(private_key)
  end

end
