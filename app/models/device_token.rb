class DeviceToken < ApplicationRecord
  validates :user_id, presence: true
  validates :device_token_type_id, presence: true
  validates :value, presence: true

  def self.build_token(user_id, value, type)
    device_type_type = DeviceTokenType.find_by(name: type)
    return nil unless device_type_type.present?

    DeviceToken.find_or_create_by(user_id: user_id, value: value, type: device_type_type.id)
  end
end
