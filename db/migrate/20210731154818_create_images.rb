class CreateImages < ActiveRecord::Migration[6.1]
  def change
    create_table :image do |t|
      t.string  :title
      t.bigint  :imageable_id
      t.string  :imageable_type

      t.timestamps
    end
    add_index :image, [:imageable_type, :imageable_id]
  end
end
