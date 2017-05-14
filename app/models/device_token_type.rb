class DeviceTokenType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
