class ChatType < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
