class CreateImages < ActiveRecord::Migration[6.1]
  def change
    create_table :images do |t|
      t.string  :title
      t.boolean :featured, default: false
      t.integer :review_id
      t.integer :writer_id
      t.integer :photographer_id
      t.integer :image_type

      t.timestamps
    end
    add_index :images, :featured
    add_index :images, :review_id
    add_index :images, :writer_id
    add_index :images, :photographer_id
    add_index :images, :image_type
  end
end
