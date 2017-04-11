class AddFullNameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :full_name, :string
    add_index :users, :full_name
    User.all.each(&:save)

    change_column :users, :full_name, :string, null: false
  end
end
