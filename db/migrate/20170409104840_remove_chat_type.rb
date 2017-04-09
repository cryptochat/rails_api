class RemoveChatType < ActiveRecord::Migration[5.0]
  def change
    remove_index :chat_channels, :chat_type_id
    remove_column :chat_channels, :chat_type_id
    drop_table :chat_types
  end
end
