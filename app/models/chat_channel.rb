class ChatChannel < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :chat_type
  has_and_belongs_to_many :users
end
