class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.datetime :reviewed_at
      t.integer :writer_id
      t.integer :photographer_id
      t.integer :restaurant_id

      t.timestamps
    end
    add_index :reviews, :restaurant_id
    add_index :reviews, :writer_id
    add_index :reviews, :photographer_id
  end
end
