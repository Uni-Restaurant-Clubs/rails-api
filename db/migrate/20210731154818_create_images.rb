class CreateImages < ActiveRecord::Migration[6.1]
  def change
    create_table :images do |t|
      t.string  :title
      t.boolean :featured, default: false
      t.integer :review_id

      t.timestamps
    end
    add_index :images, :featured
    add_index :images, :review_id
  end
end
