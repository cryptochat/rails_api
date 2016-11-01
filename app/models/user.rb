class User < ApplicationRecord
  validates :uuid,       presence: true, uniqueness: true
  validates :email,      presence: true, email: true
  validates :username,   presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name,  presence: true
end
