class DeviceToken < ApplicationRecord
  validates :user_id, presence: true
  validates :device_token_type_id, presence: true
  validates :value, presence: true

  belongs_to :user
  belongs_to :device_token_type

  def self.build_token(user_id, value, type)
    device_token_type = DeviceTokenType.find_by(name: type)
    return nil unless device_token_type.present?

    DeviceToken.find_or_create_by(user_id: user_id, value: value, device_token_type_id: device_token_type.id)
  end
end
