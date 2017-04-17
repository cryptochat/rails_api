class AddInterlocutorIdToChatMessages < ActiveRecord::Migration[5.0]
  def change
    add_column :chat_messages, :interlocutor_id, :integer
    add_foreign_key :chat_messages, :users, column: :interlocutor_id
  end
end
