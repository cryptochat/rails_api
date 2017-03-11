class RenameSessionKeysUuidColumn < ActiveRecord::Migration[5.0]
  def change
    rename_column :session_keys, :uuid, :identifier
  end
end
