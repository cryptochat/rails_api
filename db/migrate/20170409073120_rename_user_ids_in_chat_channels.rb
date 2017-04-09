class RenameUserIdsInChatChannels < ActiveRecord::Migration[5.0]
  def change
    rename_column :chat_channels, :user_ids, :cache_user_ids
  end
end
