class CreateLogEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :log_events do |t|
      t.integer :user_id
      t.integer :restaurant_id
      t.string :event_name
      t.string :label
      t.integer :category
      t.text :properties

      t.timestamps
    end
    add_index :log_events, :user_id
    add_index :log_events, :restaurant_id
    add_index :log_events, :event_name
    add_index :log_events, :label
    add_index :log_events, :category
  end
end
