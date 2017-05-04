class ChatMessage < ApplicationRecord
  validates :user_id,         presence: true, numericality: true
  validates :interlocutor_id, presence: true, numericality: true
  validates :chat_channel_id, presence: true, numericality: true
  validates :text, presence: true

  MAX_LIMIT = 40

  belongs_to :chat_channel
  belongs_to :user
  belongs_to :interlocutor, class_name: 'User', foreign_key: 'interlocutor_id'

  after_create :broadcast_message

  class << self
    def send_message(sender_id, recipient_id, message)
      chat_channel = ChatChannel.find_or_create(sender_id, recipient_id)
      create(user_id: sender_id, interlocutor_id: recipient_id, text: message, chat_channel_id: chat_channel.id)
    end

    def history(current_user_id, interlocutor_id, offset = 0, limit = 20)
      offset ||= 0
      limit = if limit.present?
                limit >= MAX_LIMIT ? MAX_LIMIT : limit
              else
                20
              end

      chat_channel = ChatChannel.find_or_create(current_user_id, interlocutor_id)
      includes(:user).where(chat_channel_id: chat_channel.id).offset(offset).limit(limit).order(created_at: :desc)
    end

    def interlocutors(current_user_id)
      subquery = <<-SQL
        LEFT JOIN (
          SELECT DISTINCT ON (chat_channel_id) *
          FROM chat_messages ORDER BY chat_channel_id, created_at DESC 
        ) AS cm ON cm.chat_channel_id = chat_channels.id
      SQL

      select('*')
          .from('chat_channels')
          .includes(:user, :interlocutor)
          .joins(subquery)
          .where('chat_channels.cache_user_ids @> ARRAY[?]', current_user_id)
          .order('cm.created_at DESC')
    end

    def read_all!(user_id)
      where(is_read: false, user_id: user_id).update_all(is_read: true, readed_at: Time.now.utc)
    end
  end

  # TODO: кэширование
  def sender
    User.find_by(id: user_id)
  end

  # TODO: кэширование
  def recipient
    User.find_by(id: interlocutor_id)
  end

  def read?
    is_read
  end

  private

  def render_incoming_message(obj, confirmation)
    ApplicationController.render(template: 'api/v1/chat_messages/incoming_message',
                                 locals: { message: obj, method_name: confirmation })
  end

  # TODO: move to sidekiq
  def broadcast_message
    message_for_sender = render_incoming_message(self, 'confirmation_message')
    WsChatChannel.broadcast_to(sender, Encryption.encrypt(message_for_sender))
    if recipient.online?
      message_for_recipient = render_incoming_message(self, 'incoming_message')
      WsChatChannel.broadcast_to(recipient, Encryption.encrypt(message_for_recipient))
    else
      # push notify
    end
  end
end
