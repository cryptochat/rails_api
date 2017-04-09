class ChatMessage < ApplicationRecord
  validates :user_id, presence: true, numericality: true
  validates :chat_channel_id, presence: true, numericality: true
  validates :text, presence: true

  belongs_to :chat_channel
  belongs_to :user

  after_create :broadcast_message

  def self.send_message(sender_id, recipient_id, message)
    chat_channel = ChatChannel.find_or_create(sender_id, recipient_id)
    create(user_id: sender_id, text: message, chat_channel_id: chat_channel.id)
  end

  def self.history(current_user_id, interlocutor_id, offset = 0, limit = 20)
    chat_channel = ChatChannel.find_or_create(current_user_id, interlocutor_id)
    where(chat_channel_id: chat_channel.id).offset(offset).limit(limit).order(created_at: :desc)
  end

  def self.read_all!(user_id)
    where(is_read: false, user_id: user_id).update_all(is_read: true, readed_at: Time.now.utc)
  end

  def read?
    is_read
  end

  private

  def broadcast_message
    # code
  end
end
