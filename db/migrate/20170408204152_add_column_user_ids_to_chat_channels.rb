class AddColumnUserIdsToChatChannels < ActiveRecord::Migration[5.0]
  def change
    add_column :chat_channels, :user_ids, :integer, array: true, default: []
    add_index :chat_channels, :user_ids, using: :gin
  end
end
