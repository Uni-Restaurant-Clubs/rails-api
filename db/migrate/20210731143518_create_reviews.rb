class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.integer :restaurant_id

      t.timestamps
    end
    add_index :reviews, :restaurant_id
  end
end
