class CreateTokens < ActiveRecord::Migration[5.0]
  def change
    create_table :tokens do |t|
      t.belongs_to :user
      t.string :value
      t.timestamps
    end
  end
end
