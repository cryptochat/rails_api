class DeviceTokenType < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :device_tokens, dependent: :destroy
end
