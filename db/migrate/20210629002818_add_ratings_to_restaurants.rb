class AddRatingsToRestaurants < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :starred, :boolean, default: false
    add_column :restaurants, :urc_rating, :integer, default: 0
    add_index :restaurants, :starred
    add_index :restaurants, :urc_rating
  end
end
