class CreateUsersAndSessionKeys < ActiveRecord::Migration[5.0]
  def change

    execute <<-SQL
      CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
    SQL

    create_table :session_keys do |t|
      t.uuid :uuid, default: 'uuid_generate_v4()'
      t.string :public_key
      t.string :private_key
      t.string :shared_key
      t.timestamps
    end

    create_table :users do |t|
      t.uuid :uuid, default: 'uuid_generate_v4()'
      t.string :email, null: false
      t.string :password, null: false
      t.string :username
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :shared_key
      t.string :hmac_key
      t.datetime :last_password_update
      t.datetime :last_shared_key_update
      t.integer :failed_attempts_auth, default: 0
      t.boolean :is_active, default: true
      t.timestamps
    end

    add_index :users, :uuid, unique: true
    add_index :users, :email, unique: true
    add_index :users, :username, unique: true
    add_index :users, :last_password_update
    add_index :users, :last_shared_key_update
    add_index :users, :failed_attempts_auth
    add_index :users, :is_active
  end
end
