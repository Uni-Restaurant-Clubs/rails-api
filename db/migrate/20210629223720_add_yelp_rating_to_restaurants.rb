class AddYelpRatingToRestaurants < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :yelp_rating, :float
    add_column :restaurants, :yelp_review_count, :bigint, default: 0
    add_index :restaurants, :yelp_rating
  end
end
