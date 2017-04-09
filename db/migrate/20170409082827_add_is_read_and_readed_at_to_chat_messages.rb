class AddIsReadAndReadedAtToChatMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :chat_messages, :is_read, :boolean, default: false
    add_column :chat_messages, :readed_at, :timestamp
  end
end
