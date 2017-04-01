class ChatAttachment < ApplicationRecord
  validates :chat_attachment_type_id, presence: true, numericality: true
  validates :chat_message_id, presence: true, numericality: true

  belongs_to :chat_message
  belongs_to :chat_attachment_type
end
