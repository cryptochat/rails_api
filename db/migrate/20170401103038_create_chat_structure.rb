class CreateChatStructure < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_types do |t|
      t.string :name, null: false
    end

    create_table :chat_channels do |t|
      t.string :name, null: false
      t.belongs_to :chat_type
    end

    create_table :chat_channels_users do |t|
      t.belongs_to :chat_channel
      t.belongs_to :user
    end

    create_table :chat_messages do |t|
      t.belongs_to :chat_channel
      t.belongs_to :user
      t.text :text, null: false
      t.boolean :has_attachments, default: false
      t.timestamps
    end

    create_table :chat_attachment_types do |t|
      t.string :name, null: false
    end

    create_table :chat_attachments do |t|
      t.belongs_to :chat_message, null: false
      t.belongs_to :chat_attachment_type, null: false
      t.string :value
      t.timestamps
    end

    add_index :chat_types, :name, unique: true
    add_index :chat_channels, :name, unique: true
    add_index :chat_attachment_types, :name, unique: true

    add_foreign_key :chat_channels, :chat_types
    add_foreign_key :chat_channels_users, :chat_channels
    add_foreign_key :chat_channels_users, :users
    add_foreign_key :chat_messages, :chat_channels
    add_foreign_key :chat_messages, :users
    add_foreign_key :chat_attachments, :chat_messages
    add_foreign_key :chat_attachments, :chat_attachment_types
  end
end
