class User < ApplicationRecord
  validates :uuid,       presence: true, uniqueness: true
  validates :email,      presence: true, email: true
  validates :username,   presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name,  presence: true

  before_create :generate_uuid

  private

    def generate_uuid
      self.uuid = loop do
        random_uuid = SecureRandom.uuid
        break random_uuid unless self.class.exists?(uuid: random_uuid)
      end
    end

end
