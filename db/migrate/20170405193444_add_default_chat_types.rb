class AddDefaultChatTypes < ActiveRecord::Migration[5.0]
  def change
    ChatType.create name: 'direct'
    ChatType.create name: 'group'
  end
end
