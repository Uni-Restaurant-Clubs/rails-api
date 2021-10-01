class AddSchedulingUpdatesToRestaurants < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :accepted_at, :datetime
    add_column :restaurants, :option_1, :datetime
    add_column :restaurants, :option_2, :datetime
    add_column :restaurants, :option_3, :datetime
    add_column :restaurants, :initial_offer_sent_to_creators, :boolean, default: false
    add_column :restaurants, :writer_confirmed, :boolean, default: false
    add_column :restaurants, :photographer_confirmed, :boolean, default: false
    add_column :restaurants, :restaurant_confirmed_final_time, :boolean, default: false
    add_column :restaurants, :confirmed_with_restaurant_day_of_review, :boolean, default: false
    add_column :restaurants, :confirmed_with_writer_day_of_review, :boolean, default: false
    add_column :restaurants, :confirmed_with_photographer_day_of_review, :boolean, default: false
    add_column :restaurants, :photographer_handed_in_photos, :boolean, default: false
    add_column :restaurants, :date_photos_received, :datetime
    add_column :restaurants, :writer_handed_in_article, :boolean, default: false
    add_column :restaurants, :date_article_received, :datetime
    add_column :restaurants, :photographer_id, :integer
    add_column :restaurants, :writer_id, :integer
    add_index :restaurants, :photographer_id
    add_index :restaurants, :writer_id
  end
end
