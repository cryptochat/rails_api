class CreateDeviceTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :device_token_types do |t|
      t.string :name
    end

    create_table :device_tokens do |t|
      t.belongs_to :user
      t.belongs_to :device_token_type
      t.string :value, null: false
      t.timestamps
    end

    add_foreign_key :device_tokens, :users
    add_foreign_key :device_tokens, :device_token_types

    add_index :device_token_types, :name, unique: true

    DeviceTokenType.create(name: 'apple')
    DeviceTokenType.create(name: 'google')
  end
end
