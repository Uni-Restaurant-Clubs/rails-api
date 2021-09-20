class CreateRestaurantCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :restaurant_categories do |t|
      t.string :alias
      t.string :title

      t.timestamps
    end
    add_index :restaurant_categories, :alias
  end
end
