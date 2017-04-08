class ChatMessage < ApplicationRecord
  validates :user_id, presence: true, numericality: true
  validates :chat_channel_id, presence: true, numericality: true
  validates :text, presence: true

  belongs_to :chat_channel
  belongs_to :user

  def self.send_message(sender_id, recipient_id, message)

  end
end
