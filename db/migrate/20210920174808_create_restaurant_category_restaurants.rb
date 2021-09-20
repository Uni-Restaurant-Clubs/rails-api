class CreateRestaurantCategoryRestaurants < ActiveRecord::Migration[6.1]
  def change
    create_table :restaurant_category_restaurants do |t|
      t.integer :restaurant_id
      t.integer :restaurant_category_id

      t.timestamps
    end
    add_index :restaurant_category_restaurants, :restaurant_id
    add_index :restaurant_category_restaurants, :restaurant_category_id
  end
end
