class CreateSessions < ActiveRecord::Migration[6.1]
  def change
    create_table :sessions do |t|
      t.string :token
      t.integer :user_id
      t.datetime :last_used

      t.timestamps
    end
    add_index :sessions, :user_id
  end
end
