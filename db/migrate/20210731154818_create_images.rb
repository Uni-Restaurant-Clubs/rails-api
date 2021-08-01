class CreateImages < ActiveRecord::Migration[6.1]
  def change
    create_table :images do |t|
      t.string  :title
      t.integer :photographer_id
      t.boolean :featured, default: false
      t.integer :review_id
      t.integer :restaurant_id

      t.timestamps
    end
    add_index :images, :photographer_id
    add_index :images, :featured
    add_index :images, :review_id
    add_index :images, :restaurant_id
  end
end
